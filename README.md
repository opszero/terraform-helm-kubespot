# Kubespot (Helm)

 - cert-manager
 - datadog
 - keda
 - nginx
 - prometheus
 - vault

# Configuration
## cert-manager

To use cert-manager add the following annotation to your Ingress

``` yaml
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

# Support
<a href="https://www.opszero.com"><img src="http://assets.opszero.com.s3.amazonaws.com/images/opszero_11_29_2016.png" width="300px"/></a>

This project is by [opsZero](https://www.opszero.com). We help organizations
migrate to Kubernetes so [reach out](https://www.opszero.com/#contact) if you
need help!
