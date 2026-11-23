resource "helm_release" "nginx_inc" {
  count            = var.nginx_inc_enable ? 1 : 0
  name             = "nginx-inc"
  repository       = "oci://ghcr.io/nginx/charts"
  chart            = "nginx-ingress"
  version          = var.nginx_inc_version
  namespace        = "nginx-inc"
  create_namespace = true

  values = [
    var.nginx_inc_yml_file != null ?
    file(var.nginx_inc_yml_file) :
    file("${path.module}/nginx-inc.yml")
  ]
}