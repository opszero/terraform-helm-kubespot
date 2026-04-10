resource "helm_release" "tempo" {
  count            = var.grafana_otel_enabled ? 1 : 0
  name             = "tempo"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "tempo"
  namespace        = "tempo"
  create_namespace = true
  version          = var.tempo_version

  values = [
    try(
      templatefile(
        var.tempo_yml_file != null ?
        var.tempo_yml_file :
        "${path.module}/tempo.yml",
        {
          storage_class = var.storage_class
        }
      ),
      ""
    )
  ]
}