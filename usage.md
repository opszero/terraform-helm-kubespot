# Kubespot (Helm)

- cert-manager
- datadog
- keda
- nginx
- prometheus
- grafana
- grafana loki
- kubecost

# Configuration

## cert-manager

To use cert-manager add the following annotation to your Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    # add an annotation indicating the issuer to use.
    cert-manager.io/cluster-issuer: letsencrypt
  name: myIngress
  namespace: myIngress
spec:
  tls:
    - hosts:
        - https-example.foo.com
      secretName: testsecret-tls
  rules:
    - host: https-example.foo.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: service1
                port:
                  number: 80
```

# Grafana

Grafana is installed on a ClusterIP use the following to open it locally.

```
kubectl port-forward -n grafana service/grafana 6891:80
open https://localhost:6891

Username: opszero
Password: opszero
```

# Deployment

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

# Teardown

```sh
terraform destroy -auto-approve
```
