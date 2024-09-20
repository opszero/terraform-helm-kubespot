resource "helm_release" "opentelemetry_collector" {
  count = var.grafana_loki_enabled ? 1 : 0

  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"

  namespace        = "otel"
  create_namespace = true

  set {
    name  = "mode"
    value = "daemonset"
  }

  set {
    name  = "image.repository"
    value = "otel/opentelemetry-collector-k8s"
  }

  set {
    name  = "command.name"
    value = "otelcol-k8s"
  }

  # Optional: You can add other settings as needed.
}
