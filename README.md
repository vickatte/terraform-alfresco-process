# Terraform template for AAE

Those terraform template can create and destroy environments in Rancher using terraform

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

See <https://helm.sh/docs/using_helm/#installing-helm>

On Mac OS X via brew:
```
brew install kubernetes-helm
```

### install Terraform

See <https://learn.hashicorp.com/terraform/getting-started/install.html>

On Mac OS X via brew:
```
brew install terraform
```

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

        terraform apply -target=rancher2_cluster.aps2-cluster

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

        echo "kubernetes_api_server = \"$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')\"" >> terraform.tfvars
        echo "kubernetes_token = \"$(kubectl config view --minify -o jsonpath='{.users[0].user.token}')\"" >> terraform.tfvars

7.  Execute the following command to populate your IP address in the `terraform.tfvars`:

        echo "my_ip_address = \"$(curl https://ipecho.net/plain)/32\"" >> terraform.tfvars

8. Then from now on you can just complete the installation everything (in case of errors with this step, please try to execute agian only this step):

        terraform apply

9. To uninstall everything:

        terraform destroy

