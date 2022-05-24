variable "nginx_name" {
  default     = "nginx"
  description = "The release name of nginx ingress helm chart"
}

variable "nginx_replica_count" {
  default     = 1
  description = "The replica count of nginx ingress controller"
}

variable "nginx_yml_file" {
  default = null
}

variable "cert_manager_email" {
  default     = null
  description = "Your email address to use for cert manager"
}

variable "datadog_api_key" {
  default     = ""
  description = "The API key of the datadog"
}

variable "datadog_values" {
  default     = ""
  description = "Values for datadog helm chart"
}

variable "datadog_values_extra" {
  default     = []
  description = "List of extra values for datadog helm chart"
}
