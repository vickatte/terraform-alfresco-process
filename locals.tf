locals {
  http              = "false"
  cluster_name      = "${var.cluster_name == "" ? "${var.project_name}${var.project_environment}" : var.cluster_name}"
  cluster_domain    = "${local.cluster_name}.${var.aws_zone_domain}"
  wildcard_host     = "*.${local.cluster_domain}"
  protocol          = "${local.http ? "http" : "https"}"
  gateway_host      = "gateway.${local.cluster_domain}"
  gateway_url       = "${local.protocol}://${local.gateway_host}"
  identity_host     = "identity.${local.cluster_domain}"
  identity_url      = "${local.protocol}://${local.identity_host}/auth"
  quay_host         = "${var.quay_url}"
  registry_host     = "registry.${local.cluster_domain}"
  registry_url      = "${local.protocol}://${local.registry_host}"
  registry_user     = "${var.registry_user}"
  registry_password = "${var.registry_password}"
  registry_email    = "${local.registry_user}@${var.aws_zone_domain}"
  acs_host          = "${local.gateway_host}"
  acs_url           = "${local.protocol}://${local.acs_host}"
}
