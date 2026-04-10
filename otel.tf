resource "helm_release" "opentelemetry_collector" {
  count = var.grafana_otel_enabled ? 1 : 0

  name             = "otel-collector"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  namespace        = "otel"
  create_namespace = true
  version          = var.opentelemetry_collector_version
  values = [
    try(
      file(
        var.otel_yml_file != null ?
        var.otel_yml_file :
        "${path.module}/otel.yml"
      ),
      ""
    )
  ]

  set = [
    {
      name  = "image.repository"
      value = "otel/opentelemetry-collector-contrib"
    },
    {
      name  = "image.tag"
      value = "0.102.1"
    },
    {
      name  = "command.name"
      value = "otelcol-contrib"
    }
  ]
}