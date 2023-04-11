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
    value = var.prometheus_persistence_storage
  }

  dynamic "set" {
    for_each = var.pushgateway_ingress_host == [] ? [] : [1]
    content {
      name  = "prometheus-pushgateway.enabled"
      value = true
    }
  }

  dynamic "set" {
    for_each = var.pushgateway_ingress_host == [] ? [] : [1]
    content {
      name  = "prometheus-pushgateway.ingress.enabled"
      value = true
    }

  }

  dynamic "set" {
    for_each = var.pushgateway_ingress_host == [] ? [] : [1]
    content {
      name  = "prometheus-pushgateway.ingress.hosts"
      value = var.pushgateway_ingress_host
    }
  }

  ## Prometheus server data Persistent Volume existing claim name
  ## Requires server.persistentVolume.enabled: true
  ## If defined, PVC must be created manually before volume will be bound
  ## Example if we want to use EFS, create storage class and pvc and add the
  ## claim name here
  dynamic "set" {
    for_each = var.prometheus_persistence_storage != false ? [1] : []
    content {
      name  = "server.persistentVolume.existingClaim"
      value = ""
    }
  }

  dynamic "set" {
    for_each = var.prometheus_persistence_storage != false ? [1] : []
    content {
      name  = "server.persistentVolume.size"
      value = "8Gi"
    }
  }

  set {
    name  = "alertmanager.persistentVolume.enabled"
    value = false
  }
}
