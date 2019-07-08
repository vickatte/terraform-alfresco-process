# adf_app module

Installs an extra ADF application like demo-shell.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| adf\_app\_image\_pull\_policy | pull policy of a custom extra ADF app to install | string | `"IfNotPresent"` | no |
| adf\_app\_image\_repository | image of a custom extra ADF app to install | string | `"alfresco/demo-shell"` | no |
| adf\_app\_image\_tag | tag of a custom extra ADF app to install | string | `"latest"` | no |
| adf\_app\_name | extra ADF app to install if set at same path | string | `""` | no |
| cluster\_domain | cluster domain | string | n/a | yes |
| gateway\_host | gateway host | string | n/a | yes |
| identity\_host | identity host | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
