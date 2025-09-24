resource "helm_release" "cert-manager" {
  count            = var.cert_manager_enable ? 1 : 0
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = var.cert_manager_version

  set = concat(
    [
      {
        name  = "installCRDs"
        value = true
      },
      {
        name  = "global.leaderElection.namespace"
        value = var.cert_manager_leader_election_namespace
      }
    ],
    var.cert_manager_resources != null ? flatten([
      for k, v in tomap(var.cert_manager_resources) : [
        {
          name  = "global.resources.${k}.cpu"
          value = try(v.cpu, null)
        },
        {
          name  = "global.resources.${k}.memory"
          value = try(v.memory, null)
        }
      ]
    ]) : []
  )

}

locals {
  cert_manager_cluster_issuer = var.cert_manager_enable && var.cert_manager_email != null ? trimspace(<<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: "${var.cert_manager_email}"
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: letsencrypt-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
  ) : ""
}


resource "null_resource" "cert-manager-cluster-issuer" {
  count = var.cert_manager_enable && var.cert_manager_email != null ? 1 : 0

  triggers = {
    manifest_sha1 = "${sha1("${local.cert_manager_cluster_issuer}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${local.cert_manager_cluster_issuer}\nEOF"
  }

  depends_on = [
    helm_release.cert-manager
  ]
}
