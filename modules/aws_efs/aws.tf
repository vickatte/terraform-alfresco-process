data "aws_eks_cluster" "aae-cluster" {
  name = "${var.cluster_name}"
}

resource "aws_efs_file_system" "aae-efs" {
  tags = {
    Name = "${var.cluster_name}"
  }

  depends_on = [
    "data.aws_eks_cluster.aae-cluster",
  ]
}

resource "aws_efs_mount_target" "aae-efs-mount-target" {
  count = "3"

  // count = "${data.aws_eks_cluster.aae-cluster.vpc_config ? length(data.aws_eks_cluster.aae-cluster.vpc_config.0.subnet_ids) : 0}" // hardcoded to let apply pass
  file_system_id  = "${aws_efs_file_system.aae-efs.id}"
  subnet_id       = "${element(data.aws_eks_cluster.aae-cluster.vpc_config.0.subnet_ids, count.index)}"
  security_groups = ["${data.aws_eks_cluster.aae-cluster.vpc_config.0.security_group_ids}"]

  depends_on = [
    "data.aws_eks_cluster.aae-cluster",
  ]
}

resource "aws_security_group_rule" "allow_nfs" {
  type              = "ingress"
  description       = "NFS used for Persistent volume claims in k8s"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = "${element(data.aws_eks_cluster.aae-cluster.vpc_config.0.security_group_ids, 0)}"
  cidr_blocks       = ["0.0.0.0/0"]
}
