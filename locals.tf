locals {
  cluster_name   = var.cluster_name == "" ? "${var.project_name}${var.project_environment}" : var.cluster_name
  cluster_domain = "${local.cluster_name}.${var.zone_domain}"
  wildcard_host  = "*.${local.cluster_domain}"
  protocol       = var.http ? "http" : "https"
  gateway_url    = "${local.protocol}://${local.gateway_host}"
  identity_host  = "identity.${local.cluster_domain}"
  identity_url   = "${local.protocol}://${local.identity_host}/auth"
  registry_host  = var.registry_host == "" ? "registry.${local.cluster_domain}" : var.registry_host
  gateway_host   = var.gateway_host == "" ? "gateway.${local.cluster_domain}" : var.gateway_host
  registry_email = "${var.registry_user}@${var.zone_domain}"
  acs_host       = local.gateway_host
  acs_url        = "${local.protocol}://${local.acs_host}"
}

