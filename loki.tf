# Generate a unique, lowercase bucket name
resource "random_id" "s3_bucket_id" {
  count       = var.grafana_enabled && var.grafana_loki_enabled ? 1 : 0
  byte_length = 15 # Generates a 16-character string in hex format (8 bytes * 2 characters per byte)
}

# S3 Bucket
resource "aws_s3_bucket" "s3_loki" {
  bucket = "grafana-loki-${random_id.s3_bucket_id[0].hex}"
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_loki" {
  bucket                  = aws_s3_bucket.s3_loki.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


# Create a KMS key for encryption
resource "aws_kms_key" "s3_loki_key" {
  description         = var.kms_key_description
  enable_key_rotation = var.enable_key_rotation
}

resource "aws_kms_alias" "s3_loki_alias" {
  name          = var.kms_alias_name
  target_key_id = aws_kms_key.s3_loki_key.id
}

# Enable default encryption for the S3 bucket using a customer-managed key
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_loki" {
  bucket = aws_s3_bucket.s3_loki.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_loki_key.arn
    }
  }
}


# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "s3_loki" {
  bucket = aws_s3_bucket.s3_loki.id

  versioning_configuration {
    status = "Enabled"
  }
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






