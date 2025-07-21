resource "random_password" "grafana_admin_password" {
  count   = var.grafana_enabled && var.grafana_admin_password == "" ? 1 : 0
  length  = 16
  special = true
}


resource "helm_release" "grafana" {
  count = var.grafana_enabled ? 1 : 0

  chart            = "grafana"
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"
  version          = var.grafana_version
  values = [
    templatefile("${path.module}/grafana.yml", {
      GOOGLE_CLIENT_ID     = var.grafana_google_auth_client_id
      GOOGLE_CLIENT_SECRET = var.grafana_google_auth_client_secret,
      INGRESS_ENABLED      = var.grafana_ingress_enabled,
      INGRESS_CLASS_NAME   = var.grafana_ingress_class_name,
      INGRESS_HOSTS        = var.grafana_ingress_hosts,
      datasources          = var.grafana_datasources,
      grafana_loki_enabled = var.grafana_loki_enabled,
      storage_class = var.grafana_efs_storage_class_name,
    }),
    var.grafana_extra_yml != null ? var.grafana_extra_yml : ""
  ]

  set = concat([
    {
      name  = "persistence.enabled"
      value = tostring(var.grafana_persistence_storage)
    },
    {
      name  = "adminUser"
      value = var.grafana_admin_user
    },
    {
      name  = "adminPassword"
      value = var.grafana_admin_password != "" ? var.grafana_admin_password : random_password.grafana_admin_password[0].result
    }
  ],
    var.grafana_persistence_storage != false ? [{
      name  = "persistence.storageClassName"
      value = var.grafana_efs_storage_class_name
    }] : [],

    # until upstream is fixed
    # https://github.com/grafana/helm-charts/issues/814
    var.grafana_efs_enable != false ? [{
      name  = "initChownData.enabled"
      value = "false"
    }] : []
  )
}