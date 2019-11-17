# rancher-eks AAE example

This example creates an EKS cluster in AWS via Rancher2 and installs AAE.

## Prerequisites

Same requirements as in the module plus as follows.

### install Rancher2

Follow the Rancher2 documentation: <https://rancher.com/docs/rancher/v2.x/en/installation/ha/>

## How to use it

As the terraform providers config is static the terraform command must be split into two steps.

1. Clone this repo and go to the root folder of the repo (where this README is located)

2. Initialize terraform:

        terraform init

3. Create your terraform variables file from the template file `terraform_template.tfvars`:

    - `cp terraform_template.tfvars terraform.tfvars`
    - edit `terraform.tfvars` and populate the variables following their description to customise your installation

   *NB* the terraform state is not managed and goes to the local file `terraform.tfstate`,
   you might want to set a terraform backend and store it for example on S3, see <https://learn.hashicorp.com/terraform/getting-started/remote.html>

4. Create an EKS cluster on Rancher:

        terraform apply -target=rancher2_cluster.aae-cluster

    It's going to take long, like 20m.

5. Run the following commands to create a `kubeconfig` file for your new cluster:

        export KUBECONFIG=$PWD/.terraform/kubeconfig
        echo "$(terraform output kube_config)" > $KUBECONFIG
        kubectl cluster-info

   *NB* optionally you can import this file in your global `kubectl` config:

        cp ~/.kube/config ~/.kube/config.backup
        KUBECONFIG=$KUBECONFIG:~/.kube/config kubectl config view --raw > ~/.kube/config.new
        mv ~/.kube/config.new ~/.kube/config

6. Execute the following commands to populate the Kubernetes variables in the `terraform.tfvars`:

        NAMESPACE=kube-system
        SERVICEACCOUNT=alfresco-deployment-service
        kubectl create serviceaccount -n kube-system ${SERVICEACCOUNT}
        kubectl create clusterrolebinding ${SERVICEACCOUNT}-admin-binding --clusterrole cluster-admin --serviceaccount=${NAMESPACE}:${SERVICEACCOUNT}
        echo "kubernetes_token = \"$(kubectl -n ${NAMESPACE} get secret $(kubectl -n ${NAMESPACE} get serviceaccount ${SERVICEACCOUNT} -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)\"" >> terraform.tfvars

7. Execute the following command to populate your gateway address in the `terraform.tfvars` to restrict your SSH access to kubernetes nodes:

        echo "my_ip_address = \"$(curl https://ipecho.net/plain)/32\"" >> terraform.tfvars

8. Then from now on you can just complete the installation everything (in case of errors with this step, please try to execute agian only this step):

        terraform apply

   *NB* if you have problems with helm check the Helm version Client and Server (tiller) are the same
    
        helm version
        
   if tiller is not installed or versions are different, execute:
   
        helm init --upgrade --force-upgrade --service-account=tiller

9. To uninstall everything:

        terraform destroy


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acs\_enabled | install Alfresco Content Services as part of the Alfresco Process Infrastructure | string | `"true"` | no |
| aae\_license | location of your AAE license file | string | n/a | yes |
| aws\_access\_key\_id | AWS access key | string | n/a | yes |
| aws\_region | AWS region | string | n/a | yes |
| aws\_secret\_access\_key | AWS secret key | string | n/a | yes |
| cluster\_description | description for your cluster | string | `""` | no |
| cluster\_name | name for your cluster, if not set it will be a concatenation of project_name and project_environment | string | n/a | yes |
| gateway\_host | gateway host | string | `""` | no |
| identity\_host | identity host | string | `""` | no |
| kubernetes\_api\_server | Kubernetes API server URL | string | `"https://kubernetes"` | no |
| kubernetes\_token | Kubernetes API token | string | `""` | no |
| my\_ip\_address | CIDR blocks for ssh access to cluster nodes | string | `"0.0.0.0/0"` | no |
| project\_environment | project environment like dev/prod/stagings | string | n/a | yes |
| project\_name | project name | string | n/a | yes |
| quay\_password | quay user password | string | n/a | yes |
| quay\_url | quay url in docker registry format, defaults to "quay.io" | string | `"quay.io"` | no |
| quay\_user | quay user name | string | n/a | yes |
| rancher2\_access\_key | Rancher 2 API access key for a user who can create clusters, you can login on Rancher2 and create from the "API & Keys" menu on your account or the URL /apikeys | string | n/a | yes |
| rancher2\_secret\_key | Rancher 2 API secret key for a user who can create clusters, you can login on Rancher2 and create from the "API & Keys" menu on your account or the URL /apikeys | string | n/a | yes |
| rancher2\_url | the URL of the Rancher2 server | string | n/a | yes |
| registry\_host | deployment docker registry | string | `""` | no |
| registry\_password | password for the deployment docker registry | string | `"password"` | no |
| registry\_user | username for the deployment docker registry | string | `"registry"` | no |
| ssh\_public\_key | public key for authentication on cluster nodes | string | `""` | no |
| ssh\_username | username to create user on cluster nodes | string | `"aae"` | no |
| zone\_domain | Zone domain | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| kube\_config | The new cluster config. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
