output "registry_host" {
  value = "${var.registry_host}"

  # trick to force dependency
  depends_on = [
    "helm_release.aps2-registry",
  ]
}
