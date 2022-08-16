resource "helm_release" "prometheus" {
  chart            = "grafana"
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"

  values = [
    file("${path.module}/grafana.yml")
  ]
}
