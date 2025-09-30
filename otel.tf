resource "helm_release" "opentelemetry_collector" {
  count = var.grafana_loki_enabled ? 1 : 0

  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"

  namespace        = "otel"
  create_namespace = true
  version          = var.opentelemetry_collector_version
  set = [
    {
      name  = "image.repository"
      value = "otel/opentelemetry-collector-k8s"
    },
    {
      name  = "command.name"
      value = "otelcol-k8s"
    },
    {
      name  = "mode"
      value = "daemonset"
    }
  ]

  values = [
    var.otel_yml_file != null  ?
    file(var.otel_yml_file) :
    file("${path.module}/otel.yml")
  ]
}


