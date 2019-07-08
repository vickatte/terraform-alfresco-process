output "service_account" {
  value = "tiller"

  # trick to force dependency
  depends_on = [
    "kubernetes_cluster_role_binding.tiller-clusterrole-binding",
  ]
}
