<!-- BEGIN_TF_DOCS -->
# Kubespot (Helm)

 - cert-manager
 - datadog
 - keda
 - nginx
 - prometheus

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
## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_email"></a> [cert\_manager\_email](#input\_cert\_manager\_email) | Your email address to use for cert manager | `any` | `null` | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | The API key for datadog | `string` | `""` | no |
| <a name="input_datadog_values"></a> [datadog\_values](#input\_datadog\_values) | Values for datadog helm chart | `string` | `""` | no |
| <a name="input_datadog_values_extra"></a> [datadog\_values\_extra](#input\_datadog\_values\_extra) | List of extra values for datadog helm chart | `list` | `[]` | no |
| <a name="input_nginx_max_replicas"></a> [nginx\_max\_replicas](#input\_nginx\_max\_replicas) | Maximum number of Nginx Replicas | `number` | `11` | no |
| <a name="input_nginx_min_replicas"></a> [nginx\_min\_replicas](#input\_nginx\_min\_replicas) | Minimum number of Nginx Replicas | `number` | `2` | no |
| <a name="input_nginx_name"></a> [nginx\_name](#input\_nginx\_name) | Release name for the installed helm chart | `string` | `"nginx"` | no |
| <a name="input_nginx_yml_file"></a> [nginx\_yml\_file](#input\_nginx\_yml\_file) | n/a | `any` | `null` | no |
## Resources

| Name | Type |
|------|------|
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.datadog](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.cert-manager-cluster-issuer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
## Outputs

No outputs.
<!-- END_TF_DOCS -->