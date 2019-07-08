# eks-getting-started module

This module creates an EKS cluster from the [EKS Getting Started Guide Configuration](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started) example, removing the hardcoded AWS region.

This is the full configuration from <https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html>

See that guide for additional information.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster\_name |  | string | `"terraform-eks-cluster"` | no |
| instance\_type |  | string | `"m4.large"` | no |
| kubernetes\_version |  | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_map\_aws\_auth | Config to add nodes, save to file and use with kubectl apply -f. |
| kubeconfig | The new cluster config. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
