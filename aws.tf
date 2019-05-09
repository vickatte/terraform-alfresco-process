data "aws_eks_cluster" "aps2-cluster" {
  name = "${local.cluster_name}"
}

data "aws_eks_cluster_auth" "aps2" {
  name = "${local.cluster_name}"
}

output "vpc_config" {
  value       = "${data.aws_eks_cluster.aps2-cluster.vpc_config}"
  description = "vpc_config"
}

resource "aws_efs_file_system" "aps2-efs" {
  tags = {
    Name = "${local.cluster_name}"
  }

  depends_on = [
    "data.aws_eks_cluster.aps2-cluster",
  ]
}

resource "aws_efs_mount_target" "aps2-efs-mount-target" {
  count = "3"

  // count = "${data.aws_eks_cluster.aps2-cluster.vpc_config ? length(data.aws_eks_cluster.aps2-cluster.vpc_config.0.subnet_ids) : 0}" // hardcoded to let apply pass
  file_system_id  = "${aws_efs_file_system.aps2-efs.id}"
  subnet_id       = "${element(data.aws_eks_cluster.aps2-cluster.vpc_config.0.subnet_ids, count.index)}"
  security_groups = ["${data.aws_eks_cluster.aps2-cluster.vpc_config.0.security_group_ids}"]

  depends_on = [
    "data.aws_eks_cluster.aps2-cluster",
  ]
}

resource "aws_security_group_rule" "allow_nfs" {
  type              = "ingress"
  description       = "NFS used for Persistent volume claims in k8s"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = "${element(data.aws_eks_cluster.aps2-cluster.vpc_config.0.security_group_ids, 0)}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_s3_bucket" "aps2-registry" {
  bucket        = "${local.cluster_name}-registry"
  region        = "${var.aws_region}"
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "${local.cluster_name}-registry"
  }
}
