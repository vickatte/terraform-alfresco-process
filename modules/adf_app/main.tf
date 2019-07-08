locals {
  helm_global_values = <<EOF
global:
  registryPullSecrets:
    - quay-registry-secret
  gateway:
    http: false
    host: ${var.gateway_host}
    domain: ${var.cluster_domain}
  keycloak:
    realm: alfresco
    host: ${var.identity_host}
EOF
}

data "helm_repository" "alfresco-incubator" {
  name = "alfresco-incubator"
  url  = "https://kubernetes-charts.alfresco.com/incubator"
}

resource "helm_release" "alfresco-adf-app" {
  name       = "${var.adf_app_name}"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-adf-app"
  version    = "2.1.3"

  values = [<<EOF
${local.helm_global_values}
nameOverride: "${var.adf_app_name}"
ingress:
  hostName: ${var.gateway_host}
  path: /${var.adf_app_name}
image:
  repository: ${var.adf_app_image_repository}
  tag: ${var.adf_app_image_tag}
  pullPolicy: ${var.adf_app_image_pull_policy}
EOF
  ]
}
