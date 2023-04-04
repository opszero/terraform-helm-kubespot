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

variable "grafana_enabled" {
  default     = false
  description = "Enable grafana"
}

variable "grafana_ingress_enabled" {
  default     = false
  description = "Enable grafana ingress"
}

variable "grafana_ingress_hosts" {
  default     = []
  description = "Add grafana ingress hosts"
}

variable "grafana_google_auth_client_id" {
  default = ''
  description = "Add Google Auth client id"
}

variable "grafana_google_auth_client_secret" {
  default = ''
  description = "Add Google Auth client secret"
}

variable "grafana_persistence_storage" {
  default = false
  description = "Enable persistence storage for Grafana"
}

variable "prometheus_persistence_storage" {
  default = false
  description = "Enable persistence storage for Prometheus"
}
