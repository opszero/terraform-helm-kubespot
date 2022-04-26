variable "nginx_replica_count" {
  default = 1
}

variable "nginx_yml_file" {
  default = null
}

variable "cert_manager_email" {
  default = null
}

variable "datadog_api_key" {
  default = ""
}

variable "datadog_values" {
  default = ""
}

variable "datadog_values_extra" {
  default = []
}

variable "vault_backend_bucket_name" {}

variable "vault_backend_bucket_region" {
  default = "us-east-1"
}

variable "vault_backend_bucket_kms_key" {
  default = "alias/aws/s3"
}

variable "vault_yml_file" {
  default = null
}

variable "force_detach_policies" {
  default     = false
  description = "Flag to force detachment of policies attached to the IAM role."
  type        = string
}

variable "iam_role_path" {
  default     = "/"
  description = "Path under which to create IAM role."
  type        = string
}

variable "vault_s3_kms_role_name" {
  default = "vault_s3_kms_role"
}

variable "s3_kms_policy_arns" {
  default = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"]
}

variable "eks_cluster_name" {
  description = "The name of EKS cluster to get OIDC ARN and Name"
}
