# docker_registry_aws module

Module that sets up a Docker registry on AWS backed by S3.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_access\_key\_id | AWS access key | string | n/a | yes |
| aws\_region | AWS region | string | n/a | yes |
| aws\_secret\_access\_key | AWS secret key | string | n/a | yes |
| cluster\_name | name for your cluster, if not set it will be a concatenation of project_name and project_environment | string | n/a | yes |
| helm\_service\_account | service account used by helm | string | `"tiller"` | no |
| registry\_host | registry host | string | n/a | yes |
| registry\_password | password for the deployment docker registry | string | n/a | yes |
| registry\_user | username for the deployment docker registry | string | n/a | yes |
| zone\_domain | Zone domain | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| registry\_host |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
