output "kube_config" {
  value       = "${module.aps2-cluster.kubeconfig}"
  description = "The new cluster config."
}
