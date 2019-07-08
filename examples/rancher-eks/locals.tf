locals {
  cluster_name   = "${var.cluster_name == "" ? "${var.project_name}${var.project_environment}" : var.cluster_name}"
  registry_host  = "${var.registry_host == "" ? "registry.${local.cluster_domain}" : var.registry_host}"
  gateway_host   = "${var.gateway_host == "" ? "gateway.${local.cluster_domain}" : var.gateway_host}"
  identity_host  = "${var.identity_host == "" ? "identity.${local.cluster_domain}" : var.identity_host}"
  cluster_domain = "${local.cluster_name}.${var.zone_domain}"
}
