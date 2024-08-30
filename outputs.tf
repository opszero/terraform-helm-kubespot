output "grafana_admin_password" {
  value     = try(var.grafana_admin_password != "" ? var.grafana_admin_password : random_password.grafana_admin_password[0].result, "")
  sensitive = true
}
