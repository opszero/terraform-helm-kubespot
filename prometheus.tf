resource "helm_release" "prometheus" {
  count = var.prometheus_enabled ? 1 : 0

  chart            = "prometheus"
  name             = "prometheus"
  namespace        = "prometheus"
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = var.prometheus_version

  values = concat(
    length(var.prometheus_additional_scrape_configs) > 0 ? [
      templatefile("${path.module}/prometheus_additional_scrape_config.yml", {
        SCRAPE_CONFIG = var.prometheus_additional_scrape_configs,
      })
    ] : [],
    length(var.pushgateway_ingress_host) > 0 ? [
      templatefile("${path.module}/prometheus.yml", {
        PUSH_GATEWAY_INGRESS_HOSTS = var.pushgateway_ingress_host
      })
    ] : [],
    var.prometheus_yml_file != null  ? [
      file(var.prometheus_yml_file)
    ] : []
  )

  set = concat(
    [
      {
        name  = "podSecurityPolicy.enabled"
        value = true
      },
      {
        name  = "server.retention"
        value = "1d"
      },
      {
        name  = "server.persistentVolume.enabled"
        value = var.prometheus_persistence_storage
      },
      {
        name  = "server.persistentVolume.storageClass"
        value = var.storage_class
      }
    ],
    length(var.pushgateway_ingress_host) > 0 ? [
      {
        name = "values"
        value = templatefile("${path.module}/prometheus.yml", {
          PUSH_GATEWAY_INGRESS_HOSTS = var.pushgateway_ingress_host
        })
      }
    ] : [],
    var.prometheus_persistence_storage != false ? [
      {
        name  = "server.persistentVolume.existingClaim"
        value = ""
      },
      {
        name  = "server.persistentVolume.size"
        value = "8Gi"
      }
    ] : [],
    [
      {
        name  = "alertmanager.persistence.enabled"
        value = false
      }
    ]
  )
}
