resource "helm_release" "grafana" {
  chart            = "grafana"
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"

  values = [
    file("${path.module}/grafana.yml")
  ]
}
