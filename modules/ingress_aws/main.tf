resource "helm_release" "nginx-ingress" {
  name    = "nginx-ingress"
  chart   = "stable/nginx-ingress"
  version = "1.7.0"

  values = [
    <<EOF
controller:
  config:
    generate-request-id: "true"
    proxy-read-timeout: "3600"
    proxy-send-timeout: "3600"
    ssl-redirect: "false"
    server-tokens: "false"
    use-forwarded-headers: "true"
  service:
    targetPorts:
      http: http
      https: http
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${aws_acm_certificate_validation.cert.certificate_arn}"
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https"
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: '3600'
EOF
    ,
  ]
}

