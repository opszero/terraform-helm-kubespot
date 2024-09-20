resource "helm_release" "opentelemetry_collector" {
  count = var.grafana_loki_enabled ? 1 : 0

  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"

  namespace        = "otel"
  create_namespace = true
  version          = "0.106.0"

  set {
    name  = "mode"
    value = "daemonset"
  }

  values = [
      var.otel_yml_file != null ? var.otel_yml_file : templatefile("${path.module}/otel.yml",
    ),
  ]
}

