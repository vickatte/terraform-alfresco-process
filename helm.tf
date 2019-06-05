resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --home ${path.cwd}/.terraform/helm --client-only"
  }

  depends_on = [
    "null_resource.kubeconfig"
  ]
}

data "helm_repository" "alfresco-incubator" {
  name = "alfresco-incubator"
  url  = "https://kubernetes-charts.alfresco.com/incubator"

  depends_on = [
    "null_resource.helm_init"
  ]
}

data "helm_repository" "alfresco" {
  name = "alfresco"
  url  = "https://kubernetes-charts.alfresco.com/stable"

  depends_on = [
    "null_resource.helm_init"
  ]
}

data "helm_repository" "activiti-cloud-charts" {
  name = "activiti-cloud-charts"
  url  = "https://activiti.github.io/activiti-cloud-charts"

  depends_on = [
    "null_resource.helm_init"
  ]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${local.wildcard_host}"
  validation_method = "DNS"

  tags = "${map(
    "Name", "${local.cluster_name}",
    "kubernetes.io/cluster/${local.cluster_name}", "owned"
  )}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.aws_zone_domain}."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

resource "helm_release" "nginx-ingress" {
  name    = "nginx-ingress"
  chart   = "stable/nginx-ingress"
  version = "1.6.0"

  values = [<<EOF
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
  ]

  depends_on = [
    "kubernetes_cluster_role_binding.tiller-clusterrole-binding"
  ]
}

locals {
  helm_global_values = <<EOF
global:
  registryPullSecrets:
    - quay-registry-secret
  gateway:
    http: false
    host: ${local.gateway_host}
    domain: ${local.cluster_domain}
  keycloak:
    realm: alfresco
    host: ${local.identity_host}
EOF

  modeling_service_path = "/modeling-service"
}

resource "helm_release" "alfresco-process-infrastructure" {
  name       = "aps2-infra"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-process-infrastructure"
  version    = "2.1.2"

  values = [<<EOF
${local.helm_global_values}
alfresco-infrastructure:
  persistence:
    efs:
      enabled: true
      dns: ${aws_efs_file_system.aps2-efs.dns_name}
  activemq:
    persistence:
      subPath: alfresco-content-services-enterprise/activemq-data
alfresco-content-services:
  enabled: true
  externalProtocol: ${local.protocol}
  externalHost: ${local.acs_host}
  nameOverride: alfresco-cs
  persistence:
    repository:
      data:
        subPath: alfresco-content-services-enterprise/repository-data
    filestore:
      data:
        subPath: alfresco-content-services-enterprise/filestore-data
  postgresql:
    nameOverride: postgresql-acs-ee
    persistence:
      subPath: alfresco-content-services-enterprise/database-data
  alfresco-search:
    nameOverride: alfresco-search
    repository:
      host: alfresco-cs
    persistence:
      enabled: false
      existingClaim: alfresco-volume-claim
      search:
        data:
          subPath: alfresco-content-services-enterprise/solr-data
  repository:
    ingress:
      hostName: ${local.acs_host}
  share:
    ingress:
      hostName: ${local.acs_host}
alfresco-digital-workspace:
  ingress:
    hostName: ${local.acs_host}
EOF
  ]

  provisioner "local-exec" {
    command = "${path.cwd}/setup_acs.sh"

    environment {
      GATEWAY_URL = "${local.acs_url}"
    }
  }

  depends_on = [
    "kubernetes_cluster_role_binding.tiller-clusterrole-binding",
    "helm_release.nginx-ingress",
    "kubernetes_secret.quay-registry-secret",
    "aws_route53_record.ingress"
  ]
}

resource "helm_release" "alfresco-content-services-ce" {
  name       = "aps2-acs-ce"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-process-infrastructure"
  version    = "2.1.2"

  values = [<<EOF
${local.helm_global_values}
alfresco-infrastructure:
  persistence:
    enabled: false
  alfresco-identity-service:
    enabled: false
  activemq:
    persistence:
      subPath: alfresco-content-services-community/activemq-data
alfresco-content-services-community:
  enabled: true
  externalProtocol: ${local.protocol}
  externalHost: ${local.acs_ce_host}
  nameOverride: alfresco-cs-ce
  persistence:
    repository:
      data:
        subPath: alfresco-content-services-community/repository-data
  postgresql:
    nameOverride: postgresql-acs-ce
    persistence:
      subPath: alfresco-content-services-community/database-data
  alfresco-search:
    nameOverride: alfresco-search
    repository:
      host: alfresco-cs-ce
    persistence:
      enabled: false
      existingClaim: alfresco-volume-claim
      search:
        data:
          subPath: alfresco-content-services-community/solr-data
  repository:
    ingress:
      hostName: ${local.acs_ce_host}
  share:
    ingress:
      hostName: ${local.acs_ce_host}
EOF
  ]

  provisioner "local-exec" {
    command = "${path.cwd}/setup_acs_ce.sh"

    environment {
      GATEWAY_URL = "${local.acs_ce_url}"
    }
  }

  depends_on = [
    "helm_release.alfresco-process-infrastructure"
  ]
}

resource "kubernetes_secret" "aps2-license" {
  metadata {
    name = "licenseaps"
  }

  data {
    "activiti.lic" = "${file(var.aps2_license)}"
  }
}

resource "helm_release" "alfresco-modeling-service" {
  name       = "aps2-modeling-service"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-process-springboot-service"
  version    = "2.1.0"

  values = [<<EOF
${local.helm_global_values}
nameOverride: alfresco-modeling-service
rbac:
  create: false
serviceAccount:
  create: false
ingress:
  enabled: true
  path: ${local.modeling_service_path}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/enable-cors: "true"
extraVolumes: |
  - name: license
    secret:
      secretName: licenseaps
extraVolumeMounts: |
  - name: license
    mountPath: "/root/.activiti/enterprise-license/"
    readOnly: true
image:
  repository: quay.io/alfresco/alfresco-modeling-service
  tag: 2.1.0
  pullPolicy: IfNotPresent
probePath: "{{ .Values.ingress.path }}/actuator/health"
extraEnv: |
  - name: SERVER_PORT
    value: "8080"
  - name: SERVER_SERVLET_CONTEXTPATH
    value: "{{ .Values.ingress.path }}"
  - name: SERVER_USEFORWARDHEADERS
    value: "true"
  - name: SERVER_TOMCAT_INTERNALPROXIES
    value: ".*"
  - name: MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
    value: "*"
  - name: CONTENT_SERVICE_URL
    value: "${local.acs_ce_url}"
EOF
  ]

  depends_on = [
    "helm_release.alfresco-process-infrastructure",
    "helm_release.alfresco-content-services-ce",
    "kubernetes_secret.quay-registry-secret",
    "kubernetes_secret.aps2-license"
  ]
}

resource "helm_release" "alfresco-modeling-app" {
  name       = "aps2-modeling"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-adf-app"
  version    = "2.1.3"

  values = [<<EOF
${local.helm_global_values}
nameOverride: "alfresco-modeling-app"
ingress:
  path: /modeling
image:
  repository: quay.io/alfresco/alfresco-modeling-app
  tag: 2.1.0
  pullPolicy: IfNotPresent
env:
  APP_CONFIG_AUTH_TYPE: "OAUTH"
  APP_CONFIG_OAUTH2_SILENT_LOGIN: "true"
  APP_CONFIG_BPM_HOST: '{{ include "common.gateway-url" . }}${local.modeling_service_path}'
EOF
  ]

  depends_on = [
    "helm_release.alfresco-modeling-service"
  ]
}

resource "helm_release" "alfresco-deployment-service-postgresql" {
  name    = "aps2-deployment-service-postgres"
  chart   = "stable/postgresql"
  version = "0.9.3"

  values = [<<EOF
nameOverride: postgres-ads
fullnameOverride: aps2-deployment-service-postgres-ads
imageTag: "10.1"
postgresUser: alfresco
postgresPassword: alfresco
postgresDatabase: ads
postgresConfig:
  max_connections: 300
  log_min_messages: LOG
persistence:
  existingClaim: "alfresco-volume-claim"
  subPath: "alfresco-deployment-service/database-data"
resources:
  requests:
    memory: "1500Mi"
  limits:
    memory: "1500Mi"
EOF
  ]

  depends_on = [
    "helm_release.alfresco-process-infrastructure"
  ]
}

resource "null_resource" "aps2-registry-htpasswd" {
  provisioner "local-exec" {
    command = "docker run --entrypoint htpasswd registry:2 -Bbn ${local.registry_user} ${local.registry_password} > ${path.cwd}/.terraform/htpasswd"
  }
}

data "local_file" "aps2-registry-htpasswd" {
  filename = "${path.cwd}/.terraform/htpasswd"

  depends_on = [
    "null_resource.aps2-registry-htpasswd"
  ]
}

resource "helm_release" "aps2-registry" {
  name    = "docker-registry"
  chart   = "stable/docker-registry"
  version = "1.8.0"

  values = [<<EOF
ingress:
  enabled: true
  hosts:
  - ${local.registry_host}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
storage: s3
secrets:
  htpasswd: ${data.local_file.aps2-registry-htpasswd.content}
  s3:
    accessKey: ${var.aws_access_key_id}
    secretKey: ${var.aws_secret_access_key}
s3:
  region: ${aws_s3_bucket.aps2-registry.region}
  bucket: ${aws_s3_bucket.aps2-registry.bucket}
EOF
  ]

  provisioner "local-exec" {
    command = "${path.cwd}/upload_images.sh"

    environment {
      QUAY_HOST         = "${local.quay_host}"
      QUAY_USER         = "${var.quay_user}"
      QUAY_PASSWORD     = "${var.quay_password}"
      REGISTRY_HOST     = "${local.registry_host}"
      REGISTRY_USER     = "${local.registry_user}"
      REGISTRY_PASSWORD = "${local.registry_password}"
    }
  }

  depends_on = [
    "helm_release.nginx-ingress",
    "aws_route53_record.ingress"
  ]
}

resource "helm_release" "alfresco-deployment-service" {
  name       = "aps2-deployment-service"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-process-springboot-service"
  version    = "2.1.0"

  values = [<<EOF
${local.helm_global_values}
nameOverride: alfresco-deployment-service
rbac:
  create: false
serviceAccount:
  create: false
rabbitmq:
  enabled: false
image:
  repository: quay.io/alfresco/alfresco-deployment-service
  tag: 2.1.0
  pullPolicy: IfNotPresent
postgres:
  enabled: true
  name: postgres-ads
  username: alfresco
  password: alfresco
  uri: "jdbc:postgresql://aps2-deployment-service-postgres-ads:5432/ads"
securityContext: |
  privileged: true
ingress:
  path: /deployment-service
  enabled: true
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/enable-cors: "true"
probePath: "{{ .Values.ingress.path }}/actuator/health"
extraVolumes: |
  - name: docker-sock-volume
    hostPath:
      path: /var/run/docker.sock
      type: File
  - name: license
    secret:
      secretName: licenseaps
extraVolumeMounts: |
  - name: docker-sock-volume
    mountPath: /var/run/docker.sock
  - name: license
    mountPath: "/root/.activiti/enterprise-license/"
    readOnly: true
extraEnv: |
  - name: SERVER_PORT
    value: "8080"
  - name: SERVER_SERVLET_CONTEXTPATH
    value: "{{ .Values.ingress.path }}"
  - name: SERVER_USEFORWARDHEADERS
    value: "true"
  - name: SERVER_TOMCAT_INTERNALPROXIES
    value: ".*"
  - name: MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE
    value: "*"
  - name: KEYCLOAK_AUTHSERVERURL
    value: '{{ include "common.keycloak-url" . }}'
  - name: DOCKER_REGISTRY_SERVER
    value: "${local.registry_host}"
  - name: DOCKER_REGISTRY_USERNAME
    value: "${local.registry_user}"
  - name: DOCKER_REGISTRY_PASSWORD
    value: "${local.registry_password}"
  - name: DOCKER_REGISTRY_SECRET_NAME
    value: "${kubernetes_secret.aps2-registry-secret.metadata.0.name}"
  - name: CONTENT_SERVICE_BASE_URL
    value: "${local.acs_url}"
  - name: MODELING_URL
    value: "${local.gateway_url}${local.modeling_service_path}"
  - name: ENVIRONMENT_HOST_URL
    value: '{{ include "common.gateway-url" . }}'
  - name: ENVIRONMENT_API_URL
    value: "${var.kubernetes_api_server}"
  - name: ENVIRONMENT_API_TOKEN
    value: "${var.kubernetes_token}"
EOF
  ]

  depends_on = [
    "helm_release.alfresco-deployment-service-postgresql",
    "helm_release.alfresco-modeling-service",
    "kubernetes_secret.quay-registry-secret",
    "kubernetes_secret.aps2-registry-secret",
    "kubernetes_secret.aps2-license"
  ]
}

resource "helm_release" "alfresco-admin-app" {
  name       = "aps2-admin"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart      = "alfresco-adf-app"
  version    = "2.1.3"

  values = [<<EOF
${local.helm_global_values}
nameOverride: "alfresco-admin-app"
ingress:
  path: /admin
image:
  repository: quay.io/alfresco/alfresco-admin-app
  tag: 2.1.0
  pullPolicy: IfNotPresent
env:
  APP_CONFIG_BPM_HOST: '{{ include "common.gateway-url" . }}'
  APP_CONFIG_AUTH_TYPE: "OAUTH"
  APP_CONFIG_IDENTITY_HOST: '{{ include "common.keycloak-url" . }}/admin/realms/{{ include "common.keycloak-realm" . }}'
EOF
  ]

  depends_on = [
    "helm_release.alfresco-deployment-service"
  ]
}

resource "helm_release" "alfresco-adf-app" {
  count = "${var.adf_app_name == "" ? 0 : 1}"
  name = "${var.adf_app_name}"
  repository = "${data.helm_repository.alfresco-incubator.url}"
  chart = "alfresco-adf-app"
  version = "2.1.3"
  values = [<<EOF
${local.helm_global_values}
nameOverride: "${var.adf_app_name}"
ingress:
  hostName: ${local.gateway_host}
  path: /${var.adf_app_name}
image:
  repository: ${var.adf_app_image_repository}
  tag: ${var.adf_app_image_tag}
  pullPolicy: ${var.adf_app_image_pull_policy}
EOF
  ]

  depends_on = [
    "helm_release.alfresco-deployment-service"
  ]
}
