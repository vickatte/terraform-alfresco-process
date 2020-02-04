# Terraform module for AAE

This terraform module allows the installation of AAE on a generic Kubernetes cluster.

## Prerequisites

Install the required tools as follows, using a package manager for operating system like [Homebrew](https://brew.sh) if available there or the generic installer in the docs.

### install Docker

Install and make sure the Docker daemon is started by starting a container, see <https://docs.docker.com/get-started/>

On Mac OS X via brew: 
```
brew cask install docker
```

### install kubectl

See <https://kubernetes.io/docs/tasks/tools/install-kubectl/>

On Mac OS X via brew:
```
brew install kubectl
```

### install helm

Version 2.12.3, see <https://helm.sh/docs/using_helm/#installing-helm>

On Mac OS X via brew:
```
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/869efd7bc843ac82a4d7f46753cb5a9c5c3949b2/Formula/kubernetes-helm.rb
```

### install Terraform

Install Terraform 0.12.x, see <https://learn.hashicorp.com/terraform/getting-started/install.html>

**Note:** Minimum Terraform version required 0.12

On Mac OS X via brew using [tfenv](https://github.com/tfutils/tfenv):
```
brew install tfenv && tfenv install
```

## How to use it

This terraform module can be either used *standalone* if you already have:

* a Kubernetes cluster
* helm installed and configured with the `tiller` service account by default (can be customised setting the `helm_service_account` variable)
* load balancer with DNS entries and SSL certificates if HTTPS
* a Docker registry

or included in another terraform script as in the [examples](#examples) which takes care of creating all of the above.

1. Clone this repo and go to the root folder of the repo (where this README is located)

2. Initialize terraform:

        terraform init

3. Create your terraform variables file from the template file `terraform_template.tfvars`:

    - `cp terraform_template.tfvars terraform.tfvars`
    - edit `terraform.tfvars` and populate the variables following their description in `variables.tf` to customise your installation

   *NB* the terraform state is not managed and goes to the local file `terraform.tfstate`,
   you might want to set a terraform backend and store it for example on S3, see <https://learn.hashicorp.com/terraform/getting-started/remote.html>

4. Execute the following commands to populate the Kubernetes variables in the `terraform.tfvars`:

        NAMESPACE=kube-system
        SERVICEACCOUNT=alfresco-deployment-service
        kubectl create serviceaccount -n kube-system ${SERVICEACCOUNT}
        kubectl create clusterrolebinding ${SERVICEACCOUNT}-admin-binding --clusterrole cluster-admin --serviceaccount=${NAMESPACE}:${SERVICEACCOUNT}
        echo "kubernetes_token = \"$(kubectl -n ${NAMESPACE} get secret $(kubectl -n ${NAMESPACE} get serviceaccount ${SERVICEACCOUNT} -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)\"" >> terraform.tfvars

5. Then from now on you can just complete the installation everything (in case of errors with this step, please try to execute again only this step):

        terraform apply

6. To uninstall everything:

        terraform destroy

## Examples

Some module usage examples are provided in the `examples` directory:

* [_eks_](./examples/eks) creates a full environment on AWS with an EKS cluster and AAE
* [_rancher_eks_](./examples/rancher-eks) creates a full environment on AWS via Rancher2 with an EKS cluster and AAE

## Documentation

Generated using [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform), run `pre-commit run -a` to update manually.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aae\_license | location of your AAE license file | string | n/a | yes |
| acs\_enabled | install Alfresco Content Services as part of the Alfresco Process Infrastructure | string | `"true"` | no |
| aws\_efs\_dns\_name | EFS DNS name to be used for ACS file storage (optional AWS only) | string | `""` | no |
| cluster\_name | name for your cluster, if not set it will be a concatenation of project_name and project_environment | string | `""` | no |
| gateway\_host | gateway host name | string | n/a | yes |
| helm\_service\_account | service account used by helm | string | `"tiller"` | no |
| http | use http rather than https for urls | string | `"false"` | no |
| kubernetes\_api\_server | Kubernetes API server URL | string | `"https://kubernetes"` | no |
| kubernetes\_token | Kubernetes API token | string | `""` | no |
| project\_environment | project environment like dev/prod/staging | string | n/a | yes |
| project\_name | project name | string | n/a | yes |
| quay\_password | quay user password | string | n/a | yes |
| quay\_url | quay url in docker registry format, defaults to "quay.io" | string | `"quay.io"` | no |
| quay\_user | quay user name | string | n/a | yes |
| registry\_host | docker registry host name | string | n/a | yes |
| registry\_password | password for the deployment docker registry | string | `"password"` | no |
| registry\_user | username for the deployment docker registry | string | `"registry"` | no |
| zone\_domain | Zone domain | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
