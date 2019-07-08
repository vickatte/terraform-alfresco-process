output "gateway_host" {
  value = "${var.gateway_host}"

  # trick to force dependency
  depends_on = [
    "helm_release.nginx-ingress",
    "aws_route53_record.ingress",
    "aws_route53_record.cert_validation",
  ]
}

output "registry_host" {
  value = "${var.registry_host}"

  # trick to force dependency
  depends_on = [
    "helm_release.nginx-ingress",
    "aws_route53_record.ingress",
    "aws_route53_record.cert_validation",
  ]
}
