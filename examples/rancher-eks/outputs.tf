output "kube_config" {
  value       = "${rancher2_cluster.aae-cluster.kube_config}"
  description = "The new cluster config."
}
