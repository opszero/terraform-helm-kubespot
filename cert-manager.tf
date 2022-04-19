resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = true
  }
}

locals = {
  cert_manager_cluster_issuer = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: "${var.cert_manager_email}"
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: letsencrypt-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
}

resource "null_resource" "cert-manager-cluster-issuer" {
  count = var.cert_manager_email == null ? 0 : 1

  triggers = {
    manifest_sha1 = "${sha1("${local.cert_manager_cluster_issuer}")}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${local.cert_manager_cluster_issuer}\nEOF"
  }

  depends_on = [
    helm_release.cert-manager
  ]
}
