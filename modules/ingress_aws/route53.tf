data "kubernetes_service" "nginx-ingress" {
  metadata {
    name = "nginx-ingress-controller"
  }

  depends_on = [helm_release.nginx-ingress]
}

data "aws_elb" "ingress" {
  name = element(
    split(
      "-",
      data.kubernetes_service.nginx-ingress.load_balancer_ingress[0].hostname,
    ),
    0,
  )
}

data "aws_route53_zone" "aae" {
  name = "${var.zone_domain}."
}

resource "aws_route53_record" "ingress" {
  count = length(local.hosts)

  zone_id = data.aws_route53_zone.aae.zone_id
  name    = element(local.hosts, count.index)
  type    = "A"

  alias {
    name                   = data.aws_elb.ingress.dns_name
    zone_id                = data.aws_elb.ingress.zone_id
    evaluate_target_health = false
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.zone_domain}."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

