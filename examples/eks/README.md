# eks AAE example

This example creates an EKS cluster in AWS and installs AAE using a module adapted from the [eks-getting-started](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started).

## Prerequisites

Same requirements as in the root module plus as follows.

   Install eksctl: https://github.com/weaveworks/eksctl

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

4. Create an EKS cluster:

         eksctl create cluster -f cluster.yaml

    It's going to take long, like 20m.

5.
   then wait for the nodes to complete joining:

        kubectl get nodes --watch

   break with CTRL-C when they are all running and the EKS cluster is ready for use.

6. Execute the following commands to populate the Kubernetes variables in the `terraform.tfvars`:

        echo "kubernetes_api_server = \"$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')\"" >> terraform.tfvars
        NAMESPACE=kube-system
        SERVICEACCOUNT=default
        kubectl create serviceaccount -n kube-system ${SERVICEACCOUNT}
        kubectl create clusterrolebinding ${SERVICEACCOUNT}-admin-binding --clusterrole cluster-admin --serviceaccount=${NAMESPACE}:${SERVICEACCOUNT}
        echo "kubernetes_token = \"$(kubectl -n ${NAMESPACE} get secret $(kubectl -n ${NAMESPACE} get serviceaccount ${SERVICEACCOUNT} -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)\"" >> terraform.tfvars
7. Execute the following command to populate your gateway address in the `terraform.tfvars` to restrict your SSH access to kubernetes nodes:

        echo "my_ip_address = \"$(curl https://ipecho.net/plain)/32\"" >> terraform.tfvars

8. Before the next step make sure you have same name for following variable in Cluster.yaml and terraform.tfvars:

     | cluster.yaml | terraform.tfvar |
     |------|-------------|
     | name   | project_name + project_environmen |
     | region | aws_region                        |
     | nodeGroups.name | node_groupname  |

9. Run the following commands to create a `kubeconfig` file for your new cluster:

           eksctl utils write-kubeconfig --name=<cluser_name> --kubeconfig=$PWD/kubeconfig --set-kubeconfig-context=true
           export KUBECONFIG=$PWD/kubeconfig
           kubectl cluster-info

10. Then from now on you can just complete the installation everything (in case of errors with this step, please try to execute agian only this step):

        terraform apply

11. To uninstall everything:

        terraform destroy

12. To destroy EKS cluster:

        eksctl delete cluster -f cluster.yaml


*NB* with this example EKS installation, provisioning an SSH key to connect to worker nodes is not supported.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acs\_enabled | install Alfresco Content Services as part of the Alfresco Process Infrastructure | string | `"true"` | no |
| aps2\_license | location of your AAE license file | string | n/a | yes |
| aws\_access\_key\_id | AWS access key | string | n/a | yes |
| aws\_region | AWS region | string | n/a | yes |
| aws\_secret\_access\_key | AWS secret key | string | n/a | yes |
| cluster\_name | name for your cluster, if not set it will be a concatenation of project_name and project_environment | string | n/a | yes |
| gateway\_host | gateway host | string | `""` | no |
| identity\_host | identity host | string | `""` | no |
| kubernetes\_api\_server | Kubernetes API server URL | string | `"https://kubernetes"` | no |
| kubernetes\_token | Kubernetes API token | string | `""` | no |
| my\_ip\_address | CIDR blocks for ssh access to cluster nodes | string | `"0.0.0.0/0"` | no |
| node\_groupname | Group name for the worker nodes | string | `"ng-1"` | no |
| project\_environment | project environment like dev/prod/stagings | string | n/a | yes |
| project\_name | project name | string | n/a | yes |
| quay\_password | quay user password | string | n/a | yes |
| quay\_url | quay url in docker registry format, defaults to "quay.io" | string | `"quay.io"` | no |
| quay\_user | quay user name | string | n/a | yes |
| registry\_host | deployment docker registry | string | `""` | no |
| registry\_password | password for the deployment docker registry | string | `"password"` | no |
| registry\_user | username for the deployment docker registry | string | `"registry"` | no |
| zone\_domain | Zone domain | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
