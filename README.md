<!-- BEGIN_TF_DOCS -->
# Kubespot (Helm)

- cert-manager
- datadog
- keda
- nginx
- prometheus
- grafana

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
# Pro Support

<a href="https://www.opszero.com"><img src="https://assets.opszero.com/images/opszero_11_29_2016.png" width="300px"/></a>

[opsZero provides support](https://www.opszero.com/devops) for our modules including:

- Email support
- Zoom Calls
- Implementation Guidance
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
| <a name="input_grafana_efs_storage_class_name"></a> [grafana\_efs\_storage\_class\_name](#input\_grafana\_efs\_storage\_class\_name) | If EFS is needed pass EFS storage class, but make sure efs and efs driver deployed | `string` | `""` | no |
| <a name="input_grafana_enabled"></a> [grafana\_enabled](#input\_grafana\_enabled) | Enable grafana | `bool` | `false` | no |
| <a name="input_grafana_google_auth_client_id"></a> [grafana\_google\_auth\_client\_id](#input\_grafana\_google\_auth\_client\_id) | Add Google Auth client id | `string` | `""` | no |
| <a name="input_grafana_google_auth_client_secret"></a> [grafana\_google\_auth\_client\_secret](#input\_grafana\_google\_auth\_client\_secret) | Add Google Auth client secret | `string` | `""` | no |
| <a name="input_grafana_ingress_enabled"></a> [grafana\_ingress\_enabled](#input\_grafana\_ingress\_enabled) | Enable grafana ingress | `bool` | `false` | no |
| <a name="input_grafana_ingress_hosts"></a> [grafana\_ingress\_hosts](#input\_grafana\_ingress\_hosts) | Add grafana ingress hosts | `list` | `[]` | no |
| <a name="input_grafana_persistence_storage"></a> [grafana\_persistence\_storage](#input\_grafana\_persistence\_storage) | Enable persistence storage for Grafana | `bool` | `false` | no |
| <a name="input_nginx_max_replicas"></a> [nginx\_max\_replicas](#input\_nginx\_max\_replicas) | Maximum number of Nginx Replicas | `number` | `11` | no |
| <a name="input_nginx_min_replicas"></a> [nginx\_min\_replicas](#input\_nginx\_min\_replicas) | Minimum number of Nginx Replicas | `number` | `2` | no |
| <a name="input_nginx_name"></a> [nginx\_name](#input\_nginx\_name) | Release name for the installed helm chart | `string` | `"nginx"` | no |
| <a name="input_nginx_yml_file"></a> [nginx\_yml\_file](#input\_nginx\_yml\_file) | n/a | `any` | `null` | no |
| <a name="input_prometheus_persistence_storage"></a> [prometheus\_persistence\_storage](#input\_prometheus\_persistence\_storage) | Enable persistence storage for Prometheus | `bool` | `false` | no |
## Resources

| Name | Type |
|------|------|
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.datadog](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.cert-manager-cluster-issuer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
## Outputs

No outputs.
<!-- END_TF_DOCS -->