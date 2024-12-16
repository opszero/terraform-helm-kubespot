// https://github.com/grafana/loki/tree/main/production/helm/loki


# S3 Bucket
resource "aws_s3_bucket" "s3_loki" {
  count  = var.grafana_loki_enabled ? 1 : 0
  bucket = var.grafana_loki_bucket_name
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_loki" {
  count               = var.grafana_loki_enabled ? 1 : 0
  bucket              = join("", aws_s3_bucket.s3_loki.*.id)
  block_public_acls   = true
  block_public_policy = true
}

# Enable default encryption for the S3 bucket using a customer-managed key
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_loki" {
  count  = var.grafana_loki_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_loki.*.id)

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "s3_loki" {
  count  = var.grafana_loki_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.s3_loki.*.id)
  versioning_configuration {
    status = "Enabled"
  }
}

resource "helm_release" "loki" {
  count            = var.grafana_loki_enabled ? 1 : 0
  chart            = "loki"
  name             = "loki"
  namespace        = "loki"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"
  version          = "6.10.2"

  values = [
    var.grafana_loki_yml_file != null ? var.grafana_loki_yml_file : templatefile("${path.module}/loki.yml", {
      s3_bucket        = join("", aws_s3_bucket.s3_loki.*.bucket),
      s3_bucket_region = join("", aws_s3_bucket.s3_loki.*.region),
      storage_class    = var.storage_class
    }),
  ]
}



resource "helm_release" "promtail" {
  count            = var.grafana_loki_enabled ? 1 : 0
  chart            = "promtail"
  name             = "promtail"
  namespace        = "loki"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"
  version          = "6.16.6"

  set {
    name  = "config.logLevel"
    value = "info"
  }

  set {
    name  = "config.serverPort"
    value = "3101"
  }

  set {
    name  = "config.clients[0].url"
    value = "http://loki-gateway.loki.svc.cluster.local/loki/api/v1/push"
  }
}
