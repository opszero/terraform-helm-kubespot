output "grafana_admin_password" {
  value = var.grafana_admin_password != "" ? var.grafana_admin_password : (
    var.grafana_enabled && var.grafana_admin_password == "" && length(random_password.grafana_admin_password) > 0
    ? random_password.grafana_admin_password[0].result
    : ""
  )
  sensitive = true
}