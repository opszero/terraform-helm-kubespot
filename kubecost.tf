resource "helm_release" "kubecost" {
  count = var.kubecost_enabled ? 1 : 0

  name             = "kubecost"
  chart            = "cost-analyzer"
  namespace        = "kubecost"
  repository       = "https://kubecost.github.io/cost-analyzer/"
  create_namespace = true
  version          = var.kubecost_version

  set = [
    {
      name  = "global.prometheus.enabled"
      value = false
    },
    {
      name  = "global.prometheus.fqdn"
      value = "http://prometheus-server.prometheus.svc:80"
    },
    {
      name  = "persistentVolume.enabled"
      value = false
    }
  ]
}
