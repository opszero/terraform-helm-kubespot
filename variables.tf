variable "nginx_name" {
  default     = "nginx"
  description = "Release name for the installed helm chart"
}

variable "nginx_yml_file" {
  default = null
}

variable "nginx_min_replicas" {
  default = 2
  description = "Minimum number of Nginx Replicas"
}

variable "nginx_max_replicas" {
  default = 11
  description = "Maximum number of Nginx Replicas"
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
