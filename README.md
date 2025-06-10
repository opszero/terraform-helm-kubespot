<!-- BEGIN_TF_DOCS -->
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
## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_email"></a> [cert\_manager\_email](#input\_cert\_manager\_email) | Your email address to use for cert manager | `any` | `null` | no |
| <a name="input_cert_manager_leader_election_namespace"></a> [cert\_manager\_leader\_election\_namespace](#input\_cert\_manager\_leader\_election\_namespace) | The namespace used for the leader election lease. Change to cert-manager for GKE Autopilot | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_resources"></a> [cert\_manager\_resources](#input\_cert\_manager\_resources) | n/a | <pre>map(object({<br/>    cpu    = string<br/>    memory = string<br/>  }))</pre> | `null` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | The version of the Cert-Manager Helm chart to be deployed, used for automating the issuance and renewal of TLS certificates. | `string` | `"1.16.3"` | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | The API key for datadog | `string` | `""` | no |
| <a name="input_datadog_values"></a> [datadog\_values](#input\_datadog\_values) | Values for datadog helm chart | `string` | `""` | no |
| <a name="input_datadog_values_extra"></a> [datadog\_values\_extra](#input\_datadog\_values\_extra) | List of extra values for datadog helm chart | `list` | `[]` | no |
| <a name="input_datadog_version"></a> [datadog\_version](#input\_datadog\_version) | The version of the Datadog Helm chart to be deployed, used for monitoring, security, and observability in Kubernetes environments. | `string` | `"3.88.3"` | no |
| <a name="input_grafana_admin_password"></a> [grafana\_admin\_password](#input\_grafana\_admin\_password) | The Password of Grafana for login Dashboard | `string` | `""` | no |
| <a name="input_grafana_admin_user"></a> [grafana\_admin\_user](#input\_grafana\_admin\_user) | The User name of Grafana for login Dashboard | `string` | `"opszero"` | no |
| <a name="input_grafana_datasources"></a> [grafana\_datasources](#input\_grafana\_datasources) | n/a | <pre>list(object({<br/>    name      = string<br/>    type      = string<br/>    url       = string<br/>    access    = string<br/>    isDefault = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_grafana_efs_enable"></a> [grafana\_efs\_enable](#input\_grafana\_efs\_enable) | Enable EFS storage for Grafana | `bool` | `false` | no |
| <a name="input_grafana_efs_storage_class_name"></a> [grafana\_efs\_storage\_class\_name](#input\_grafana\_efs\_storage\_class\_name) | If EFS is needed pass EFS storage class, but make sure efs and efs driver deployed | `string` | `"gp2"` | no |
| <a name="input_grafana_enabled"></a> [grafana\_enabled](#input\_grafana\_enabled) | Enable grafana | `bool` | `false` | no |
| <a name="input_grafana_extra_yml"></a> [grafana\_extra\_yml](#input\_grafana\_extra\_yml) | Grafana Datasources as Yaml | `any` | `null` | no |
| <a name="input_grafana_google_auth_client_id"></a> [grafana\_google\_auth\_client\_id](#input\_grafana\_google\_auth\_client\_id) | Add Google Auth client id | `string` | `""` | no |
| <a name="input_grafana_google_auth_client_secret"></a> [grafana\_google\_auth\_client\_secret](#input\_grafana\_google\_auth\_client\_secret) | Add Google Auth client secret | `string` | `""` | no |
| <a name="input_grafana_ingress_class_name"></a> [grafana\_ingress\_class\_name](#input\_grafana\_ingress\_class\_name) | Ingress class name for Grafana | `string` | `"nginx"` | no |
| <a name="input_grafana_ingress_enabled"></a> [grafana\_ingress\_enabled](#input\_grafana\_ingress\_enabled) | Enable grafana ingress | `bool` | `false` | no |
| <a name="input_grafana_ingress_hosts"></a> [grafana\_ingress\_hosts](#input\_grafana\_ingress\_hosts) | Add grafana ingress hosts | `list` | `[]` | no |
| <a name="input_grafana_loki_bucket_name"></a> [grafana\_loki\_bucket\_name](#input\_grafana\_loki\_bucket\_name) | Name for the S3 bucket | `string` | `""` | no |
| <a name="input_grafana_loki_enabled"></a> [grafana\_loki\_enabled](#input\_grafana\_loki\_enabled) | Enable grafana loki | `bool` | `false` | no |
| <a name="input_grafana_loki_yml_file"></a> [grafana\_loki\_yml\_file](#input\_grafana\_loki\_yml\_file) | n/a | `any` | `null` | no |
| <a name="input_grafana_persistence_storage"></a> [grafana\_persistence\_storage](#input\_grafana\_persistence\_storage) | Enable persistence storage for Grafana | `bool` | `true` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | The version of the Grafana Helm chart to be deployed, used for data visualization and monitoring dashboards. | `string` | `"8.8.5"` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | The version of the Ingress-NGINX Helm chart to be deployed, used for managing ingress traffic in Kubernetes. | `string` | `"4.12.1"` | no |
| <a name="input_keda_version"></a> [keda\_version](#input\_keda\_version) | The version of the KEDA Helm chart to be deployed, used for Kubernetes-based Event-Driven Autoscaling. | `string` | `"2.16.1"` | no |
| <a name="input_kubecost_enabled"></a> [kubecost\_enabled](#input\_kubecost\_enabled) | A boolean to enable or disable the deployment of Kubecost, a tool for monitoring and managing Kubernetes cost and resource usage. | `bool` | `false` | no |
| <a name="input_kubecost_version"></a> [kubecost\_version](#input\_kubecost\_version) | The version of the Kubecost Helm chart to be deployed, used for Kubernetes cost management and optimization. | `string` | `"2.5.3"` | no |
| <a name="input_loki_version"></a> [loki\_version](#input\_loki\_version) | The version of the Loki Helm chart to be deployed, used for log aggregation and analysis. | `string` | `"6.25.0"` | no |
| <a name="input_nginx_max_replicas"></a> [nginx\_max\_replicas](#input\_nginx\_max\_replicas) | Maximum number of Nginx Replicas | `number` | `11` | no |
| <a name="input_nginx_min_replicas"></a> [nginx\_min\_replicas](#input\_nginx\_min\_replicas) | Minimum number of Nginx Replicas | `number` | `2` | no |
| <a name="input_nginx_name"></a> [nginx\_name](#input\_nginx\_name) | Release name for the installed helm chart | `string` | `"nginx"` | no |
| <a name="input_nginx_yml_file"></a> [nginx\_yml\_file](#input\_nginx\_yml\_file) | n/a | `any` | `null` | no |
| <a name="input_opentelemetry_collector_version"></a> [opentelemetry\_collector\_version](#input\_opentelemetry\_collector\_version) | The version of the OpenTelemetry Collector Helm chart to be deployed, used for collecting telemetry data (logs, metrics, and traces) from various sources. | `string` | `"0.115.0"` | no |
| <a name="input_otel_yml_file"></a> [otel\_yml\_file](#input\_otel\_yml\_file) | n/a | `any` | `null` | no |
| <a name="input_prometheus_additional_scrape_configs"></a> [prometheus\_additional\_scrape\_configs](#input\_prometheus\_additional\_scrape\_configs) | Add additional scrape for configuration for prometheus if needed | <pre>list(object({<br/>    job_name        = string<br/>    targets         = list(string)<br/>    scrape_interval = string<br/>    metrics_path    = string<br/>  }))</pre> | `[]` | no |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Enable prometheus | `bool` | `true` | no |
| <a name="input_prometheus_persistence_storage"></a> [prometheus\_persistence\_storage](#input\_prometheus\_persistence\_storage) | Enable persistence storage for Prometheus | `bool` | `false` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | The version of the Prometheus Helm chart to be deployed, used for monitoring and alerting in Kubernetes. | `string` | `"27.1.0"` | no |
| <a name="input_promtail_version"></a> [promtail\_version](#input\_promtail\_version) | The version of the Promtail Helm chart to be deployed, used as a log collector to send logs to Loki. | `string` | `"6.16.6"` | no |
| <a name="input_pushgateway_ingress_host"></a> [pushgateway\_ingress\_host](#input\_pushgateway\_ingress\_host) | List of hosts for prometheus push gateway ingress | `list` | `[]` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage Class to use for Persistence | `string` | `"gp2"` | no |
## Resources

| Name | Type |
|------|------|
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.datadog](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kubecost](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.loki](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.opentelemetry_collector](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.promtail](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.cert-manager-cluster-issuer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_admin_password"></a> [grafana\_admin\_password](#output\_grafana\_admin\_password) | n/a |
# 🚀 Built by opsZero!

<a href="https://opszero.com"><img src="https://opszero.com/wp-content/uploads/2024/07/opsZero_logo_svg.svg" width="300px"/></a>

Since 2016 [opsZero](https://opszero.com) has been providing Kubernetes
expertise to companies of all sizes on any Cloud. With a focus on AI and
Compliance we can say we seen it all whether SOC2, HIPAA, PCI-DSS, ITAR,
FedRAMP, CMMC we have you and your customers covered.

We provide support to organizations in the following ways:

- [Modernize or Migrate to Kubernetes](https://opszero.com/solutions/modernization/)
- [Cloud Infrastructure with Kubernetes on AWS, Azure, Google Cloud, or Bare Metal](https://opszero.com/solutions/cloud-infrastructure/)
- [Building AI and Data Pipelines on Kubernetes](https://opszero.com/solutions/ai/)
- [Optimizing Existing Kubernetes Workloads](https://opszero.com/solutions/optimized-workloads/)

We do this with a high-touch support model where you:

- Get access to us on Slack, Microsoft Teams or Email
- Get 24/7 coverage of your infrastructure
- Get an accelerated migration to Kubernetes

Please [schedule a call](https://calendly.com/opszero-llc/discovery) if you need support.

<br/><br/>

<div style="display: block">
  <img src="https://opszero.com/wp-content/uploads/2024/07/aws-advanced.png" width="150px" />
  <img src="https://opszero.com/wp-content/uploads/2024/07/AWS-public-sector.png" width="150px" />
  <img src="https://opszero.com/wp-content/uploads/2024/07/AWS-eks.png" width="150px" />
</div>
<!-- END_TF_DOCS -->
