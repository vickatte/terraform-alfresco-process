data "template_file" "user-data" {
  template = "${file("${path.module}/user-data.conf")}"

  vars{
    ssh_username     = "${var.ssh_username}"
    ssh_public_key   = "${var.ssh_public_key}"
    ClusterName      =  "${local.cluster_name}"
    stack_name       = "${local.cluster_name}-eks-worker-nodes"
    aws_Region       = "${var.aws_region}"
  }
}

data "aws_security_groups" "eks-worker-nodes" {
  filter {
    name = "vpc-id"
    values = [
      "${data.aws_eks_cluster.aps2-cluster.vpc_config.0.vpc_id}"]
  }
}