output "kube_config" {
  value       = "${rancher2_cluster.aps2-cluster.kube_config}"
  description = "The new cluster config."
}
