resource "random_password" "s3_loki_name" {
  count   = var.grafana_enabled && var.grafana_loki_enabled ? 1 : 0
  length  = 16
  special = false
  upper   = false # Disable uppercase letters
}

# Create an S3 bucket
resource "aws_s3_bucket" "s3_loki" {
  bucket = "loki-${random_password.s3_loki_name[0].result}"
}


resource "helm_release" "loki" {
  count            = var.grafana_enabled && var.grafana_loki_enabled ? 1 : 0
  chart            = "loki"
  name             = "loki"
  namespace        = "loki"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"
  version          = "6.10.2"

  values = [
    var.loki_yml_file != null ? var.loki_yml_file : templatefile("${path.module}/loki.yml", {
    s3_bucket = aws_s3_bucket.s3_loki.bucket })
  ]

}






