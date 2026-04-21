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
    [
      templatefile("${path.module}/prometheus.yml", {
        PUSH_GATEWAY_INGRESS_HOSTS = var.pushgateway_ingress_host
      })
    ],
    [<<-EOT
      server:
        extraFlags:
          - web.enable-remote-write-receiver
    EOT
    ]
  )

  set = concat(
    [
      {
        name  = "podSecurityPolicy.enabled"
        value = true
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
    var.prometheus_persistence_storage != false ? [
      {
        name  = "server.persistentVolume.existingClaim"
        value = ""
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