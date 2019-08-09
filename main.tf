data "helm_repository" "alfresco-incubator" {
  name = "alfresco-incubator"
  url  = "https://kubernetes-charts.alfresco.com/incubator"
}

data "helm_repository" "alfresco" {
  name = "alfresco"
  url  = "https://kubernetes-charts.alfresco.com/stable"
}

resource "helm_release" "alfresco-process-infrastructure" {
  name       = "aps2"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-process-infrastructure"
  version    = "7.1.0-M4"

  values = [<<EOF
global:
  registryPullSecrets:
    - quay-registry-secret
  gateway:
    http: false
    host: "${var.gateway_host}"
    domain: "${local.cluster_domain}"
  keycloak:
    realm: alfresco
    host: "${local.identity_host}"
  acs:
    host: "${var.gateway_host}"
alfresco-infrastructure:
  persistence:
    enabled: ${var.aws_efs_dns_name != ""}
    efs:
      enabled: ${var.acs_enabled && var.aws_efs_dns_name != ""}
      dns: "${var.aws_efs_dns_name}"
  activemq:
    enabled: ${var.acs_enabled ? true : false}
alfresco-content-services:
  enabled: ${var.acs_enabled ? true : false}
  alfresco-digital-workspace:
    enabled: ${var.acs_enabled ? true : false}
alfresco-deployment-service:
  alfresco-content-services:
    enabled: ${var.acs_enabled ? true : false}
  dockerRegistry:
    server: "${var.registry_host}"
    password: "${var.registry_password}"
    userName: "${var.registry_user}"
    secretName: "aps2-registry-secret"
  environment:
    apiUrl: "${var.kubernetes_api_server}"
    apiToken: "${var.kubernetes_token}"
nfs-server-provisioner:
  enabled: ${var.acs_enabled && var.aws_efs_dns_name == ""}
EOF
  ]

  depends_on = [
    "kubernetes_secret.quay-registry-secret",
  ]
}
