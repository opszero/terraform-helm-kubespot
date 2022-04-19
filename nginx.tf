
resource "helm_release" "nginx" {
  name             = "nginx"
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

  depends_on = [
    helm_release.cert-manager,
    helm_release.prometheus,
  ]
}


resource "helm_release" "nginx2" {
  name             = "nginx2"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "nginx2"
  create_namespace = true

  values = [
    var.nginx_yml_file == null ? "${file("${path.module}/nginx.yml")}" : "${var.nginx_yml_file}"
  ]

  set {
    name  = "controller.replicaCount"
    value = var.nginx_replica_count
  }

  depends_on = [
    helm_release.cert-manager,
    helm_release.prometheus,
  ]
}
