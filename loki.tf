resource "helm_release" "grafana" {
  count = var.grafana_enabled && var.grafana_loki_enabled ? 1 : 0

  chart            = "loki"
  name             = "loki"
  namespace        = "loki"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"
  version          = "6.10.2"


  values = [
      var.loki_yml_file == null ? file("${path.module}/loki.yml") : "${var.loki_yml_file}"
  ]
}








