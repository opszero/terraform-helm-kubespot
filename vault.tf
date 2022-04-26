locals {
  vault_yml_values = templatefile("${path.module}/vault.tpl", {
    bucket_name    = var.vault_backend_bucket_name # line 161 vault.tpl
    bucket_region  = var.vault_backend_bucket_region
    kms_key_id     = var.vault_backend_bucket_kms_key
    vault_role_arn = aws_iam_role.vault_s3_kms_role.arn # line 174 vault.tpl
  })
  oidc_provider_arn  = module.oidc_provider_data.arn
  oidc_provider_name = module.oidc_provider_data.name
}

# the name of eks cluster to get oidc provider arn and name
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

# This module is for generating the OpenID Connect provider ARN one would get given an issuer url.
module "oidc_provider_data" {
  source     = "reegnz/oidc-provider-data/aws"
  version    = "0.0.2"
  issuer_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:vault:vault"]
      variable = "${local.oidc_provider_name}:sub"
    }
    principals {
      identifiers = [local.oidc_provider_arn]
      type        = "Federated"
    }
  }
  version = "2012-10-17"
}

resource "aws_iam_role" "vault_s3_kms_role" {
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  description           = "Role used by the Vault as S3 backend."
  force_detach_policies = var.force_detach_policies
  name                  = var.vault_s3_kms_role_name
  path                  = var.iam_role_path

  depends_on = [
    module.oidc_provider_data
  ]
}

resource "aws_iam_role_policy_attachment" "s3_kms" {
  count      = length(var.s3_kms_policy_arns)
  policy_arn = var.s3_kms_policy_arns[count.index]
  role       = aws_iam_role.vault_s3_kms_role.id
}

resource "null_resource" "create_vault_yml" {
  provisioner "local-exec" {
    environment = {
      // Placing these values in the environment to prevent them from being logged
      VAULT_YML_VALUES = local.vault_yml_values
    }
    command = <<EOF
echo "$VAULT_YML_VALUES" > ./vault.yml
EOF
  }
  depends_on = [
    aws_iam_role.vault_s3_kms_role
  ]
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  namespace        = "vault"
  create_namespace = true

  values = [
    var.vault_yml_file == null ? "${file("${path.module}/vault.yml")}" : "${var.vault_yml_file}"
  ]

  depends_on = [
    null_resource.create_vault_yml
  ]
}
