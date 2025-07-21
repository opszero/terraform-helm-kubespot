resource "helm_release" "nginx" {
  name             = var.nginx_name
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "nginx"
  create_namespace = true
  version          = var.ingress_nginx_version

  values = [
    var.nginx_yml_file == null ? file("${path.module}/nginx.yml") : "${var.nginx_yml_file}"
  ]

  set {
    name  = "controller.ingressClass"
    value = var.nginx_name
  }

  set {
    name  = "controller.keda.minReplicas"
    value = var.nginx_min_replicas
  }

  set {
    name  = "controller.keda.maxReplicas"
    value = var.nginx_max_replicas
  }

  depends_on = [
    helm_release.keda,
    helm_release.prometheus,
  ]
}
