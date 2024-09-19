resource "helm_release" "kubecost" {
  count = var.kubecost_enabled ? 1 : 0

  name             = "kubecost"
  chart            = "cost-analyzer"
  namespace        = "kubecost"
  repository       = "https://kubecost.github.io/cost-analyzer/"
  create_namespace = true
}
