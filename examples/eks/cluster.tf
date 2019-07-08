# Create a new EKS cluster
module "aps2-cluster" {
  source = "../../modules/eks-getting-started"

  cluster_name       = "${local.cluster_name}"
  kubernetes_version = "1.11"
  instance_type      = "m4.4xlarge"
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "echo \"${module.aps2-cluster.kubeconfig}\" > ${path.root}/.terraform/kubeconfig"
  }
}
