resource "helm_release" "prometheus" {
  chart            = "prometheus"
  name             = "prometheus"
  namespace        = "prometheus"
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.retention"
    value = "1d"
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = true
  }
  
  ## Prometheus server data Persistent Volume existing claim name
  ## Requires server.persistentVolume.enabled: true
  ## If defined, PVC must be created manually before volume will be bound
  ## Example if we want to use EFS, create storage class and pvc and add the
  ## claim name here
  set {
    name  = "server.persistentVolume.existingClaim"
    value = ''
  }

  set {
    name  = "server.persistentVolume.size"
    value = '8Gi'
  }

  set {
    name  = "alertmanager.persistentVolume.enabled"
    value = false
  }
}
