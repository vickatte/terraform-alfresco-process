# ingress_aws module

This module creates an ingress on AWS with ELB, DNS rules on Route53 and HTTPS certificate on Certificate Manager.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster\_domain | cluster domain | string | n/a | yes |
| cluster\_name | name for your cluster, if not set it will be a concatenation of project_name and project_environment | string | n/a | yes |
| gateway\_host | gateway host | string | n/a | yes |
| helm\_service\_account | service account used by helm | string | `"tiller"` | no |
| identity\_host | identity host | string | n/a | yes |
| registry\_host | registry host | string | n/a | yes |
| zone\_domain | Zone domain | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gateway\_host |  |
| registry\_host |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
