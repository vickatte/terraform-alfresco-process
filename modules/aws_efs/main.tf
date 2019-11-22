resource "helm_release" "nfs-client-provisioner" {
  name    = "nfs-client-provisioner"
  chart   = "stable/nfs-client-provisioner"
  version = "1.2.8"

  values = [<<EOF
nfs:
  server: "${aws_efs_file_system.aae-efs.dns_name}"
  path: "/"
storageClass:
  reclaimPolicy: "Delete"
  name: "default-sc"
EOF
  ]
}
