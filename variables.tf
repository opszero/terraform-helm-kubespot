variable "nginx_name" {
  default     = "nginx"
  description = "Release name for the installed helm chart"
}

variable "nginx_yml_file" {
  default = null
}

variable "nginx_min_replicas" {
  default     = 2
  description = "Minimum number of Nginx Replicas"
}

variable "nginx_max_replicas" {
  default     = 11
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
  default     = ""
  description = "Add Google Auth client id"
}

variable "grafana_google_auth_client_secret" {
  default     = ""
  description = "Add Google Auth client secret"
}

variable "grafana_persistence_storage" {
  default     = false
  description = "Enable persistence storage for Grafana"
}

variable "grafana_efs_enable" {
  default     = false
  description = "Enable EFS storage for Grafana"
}
variable "grafana_efs_storage_class_name" {
  default     = ""
  description = "If EFS is needed pass EFS storage class, but make sure efs and efs driver deployed"
}

variable "prometheus_persistence_storage" {
  default     = false
  description = "Enable persistence storage for Prometheus"
}

variable "prometheus_additional_scrape_configs" {
  type = list(object({
    job_name = string
    targets  = list(string)
  }))
  default     = []
  description = "Add additional scrape for configuration for prometheus if needed"
}

variable "pushgateway_ingress_host" {
  default     = []
  description = "List of hosts for prometheus push gateway ingress"
}

variable "prometheus_enabled" {
  default     = true
  description = "Enable prometheus"
}

variable "cert_manager_leader_election_namespace" {
  default     = "cert-manager"
  description = "The namespace used for the leader election lease"
}
