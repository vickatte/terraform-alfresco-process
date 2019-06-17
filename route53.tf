locals {
  aws_elb_name = "${element(split("-", data.kubernetes_service.nginx-ingress.load_balancer_ingress.0.hostname), 0)}"
  hosts = [
    "${local.gateway_host}",
    "${local.registry_host}",
    "${local.acs_host}"
  ]
}

data "aws_elb" "ingress" {
  name = "${local.aws_elb_name}"
}

data "aws_route53_zone" "aps2" {
  name = "${var.aws_zone_domain}."
}

resource "aws_route53_record" "ingress" {
//  count    = "${length(local.hosts)}"
  zone_id  = "${data.aws_route53_zone.aps2.zone_id}"
//  name     = "${local.hosts[count.index]}"
  name     = "${local.wildcard_host}"
  type     = "A"

  alias {
    name = "${data.aws_elb.ingress.dns_name}"
    zone_id = "${data.aws_elb.ingress.zone_id}"
    evaluate_target_health = false
  }

  depends_on = [
    "helm_release.nginx-ingress"
  ]
}
