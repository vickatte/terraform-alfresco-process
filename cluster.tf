# Create a new rancher2 eks Cluster

resource "rancher2_cluster" "aps2-cluster" {
  name        = "${local.cluster_name}"
  description = "${var.cluster_description}"

  eks_config {
    region          = "${var.aws_region}"
    instance_type   = "m4.4xlarge"
    minimum_nodes   = 1
    maximum_nodes   = 5
    access_key      = "${var.aws_access_key_id}"
    secret_key      = "${var.aws_secret_access_key}"
    security_groups = []
    service_role    = ""
    subnets         = []
    virtual_network = ""
  }
}

output "kube_config" {
  value       = "${rancher2_cluster.aps2-cluster.kube_config}"
  description = "The new cluster config."
}
