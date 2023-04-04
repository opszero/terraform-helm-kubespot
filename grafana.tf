resource "helm_release" "grafana" {
  count = var.grafana_enabled ? 1 : 0

  chart            = "grafana"
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"

  values = [
    file("${path.module}/grafana.yml")
  ]

  set {
    name  = "ingress.enabled"
    value = false
  }
}
