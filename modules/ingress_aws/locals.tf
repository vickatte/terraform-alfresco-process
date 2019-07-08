locals {
  wildcard_host = "*.${var.cluster_domain}"

  hosts = [
    "${var.gateway_host}",
    "${var.registry_host}",
    "${var.identity_host}",
  ]
}
