
resource "helm_release" "nginx" {
  name             = var.nginx_name
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "nginx"
  create_namespace = true

  values = [
    var.nginx_yml_file == null ? "${file("${path.module}/nginx.yml")}" : "${var.nginx_yml_file}"
  ]

  set {
    name  = "controller.replicaCount"
    value = var.nginx_replica_count
  }

  set {
    name  = "controller.ingressClass"
    value = var.nginx_name
  }

  set {
    name  = "controller.keda.enabled"
    value = var.nginx_autoscaling_enabled
  }

  set {
    name  = "controller.metrics.enabled"
    value = var.prometheus_enabled
  }

  set {
    name  = "controller.stats.enabled"
    value = var.prometheus_enabled
  }

  depends_on = [
    helm_release.cert-manager,
    helm_release.prometheus,
  ]
}
