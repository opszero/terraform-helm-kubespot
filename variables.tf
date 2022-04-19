variable "nginx_replica_count" {
  default = 1
}
variable "nginx_yml_file" {
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
