variable "prometheus_enabled" {
  default = false
}

variable "nginx_name" {
  default     = "nginx"
  description = "Release name for the installed helm chart"
}

variable "nginx_replica_count" {
  default     = 1
  description = "The replica count for nginx ingress controller"
}

variable "nginx_autoscaling_enabled" {
  description = "Enable nginx autoscaling"
  default     = false
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
  description = "The API key for datadog"
}

variable "datadog_values" {
  default     = ""
  description = "Values for datadog helm chart"
}

variable "datadog_values_extra" {
  default     = []
  description = "List of extra values for datadog helm chart"
}
