output "registry_host" {
  value = var.registry_host

  # trick to force dependency
  depends_on = [helm_release.aae-registry]
}

