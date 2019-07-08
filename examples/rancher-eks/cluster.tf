data "template_file" "user-data" {
  template = "${file("${path.module}/user-data.conf")}"

  vars {
    ssh_username   = "${var.ssh_username}"
    ssh_public_key = "${var.ssh_public_key}"
    ClusterName    = "${local.cluster_name}"
    stack_name     = "${local.cluster_name}-eks-worker-nodes"
    aws_Region     = "${var.aws_region}"
  }
}

# Create a new EKS cluster on AWS via Rancher2
resource "rancher2_cluster" "aps2-cluster" {
  name        = "${local.cluster_name}"
  description = "${var.cluster_description}"

  eks_config {
    region             = "${var.aws_region}"
    instance_type      = "m4.4xlarge"
    minimum_nodes      = 1
    maximum_nodes      = 5
    access_key         = "${var.aws_access_key_id}"
    secret_key         = "${var.aws_secret_access_key}"
    security_groups    = []
    service_role       = ""
    subnets            = []
    virtual_network    = ""
    user_data          = "${data.template_file.user-data.rendered}"
    kubernetes_version = "1.11"
  }
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "echo \"${rancher2_cluster.aps2-cluster.kube_config}\" > ${path.root}/.terraform/kubeconfig"
  }
}

data "aws_security_groups" "eks-worker-nodes" {
  filter {
    name = "vpc-id"

    values = [
      "${data.aws_eks_cluster.aps2-cluster.vpc_config.0.vpc_id}",
    ]
  }

  filter {
    name   = "group-name"
    values = ["${local.cluster_name}-eks-worker-nodes-NodeSecurityGroup*"]
  }
}

# Allow SSH access to cluster nodes
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  description       = "SSH to worker nodes of the cluster"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${element(data.aws_security_groups.eks-worker-nodes.ids, 2)}"
  cidr_blocks       = ["${var.my_ip_address}"]

  depends_on = [
    "data.aws_security_groups.eks-worker-nodes",
  ]
}
