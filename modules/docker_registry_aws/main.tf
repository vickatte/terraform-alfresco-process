resource "helm_release" "aae-registry" {
  name    = "docker-registry"
  chart   = "stable/docker-registry"
  version = "1.8.0"

  values = [
    <<EOF
ingress:
  enabled: true
  hosts:
  - ${var.registry_host}
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
storage: s3
secrets:
  htpasswd: ${data.local_file.aae-registry-htpasswd.content}
  s3:
    accessKey: ${var.aws_access_key_id}
    secretKey: ${var.aws_secret_access_key}
s3:
  region: ${aws_s3_bucket.aae-registry.region}
  bucket: ${aws_s3_bucket.aae-registry.bucket}
EOF
    ,
  ]
}

resource "null_resource" "aae-registry-htpasswd" {
  provisioner "local-exec" {
    command = "docker run --entrypoint htpasswd registry:2 -Bbn ${var.registry_user} ${var.registry_password} > ${path.cwd}/.terraform/htpasswd"
  }
}

data "local_file" "aae-registry-htpasswd" {
  filename = "${path.cwd}/.terraform/htpasswd"

  depends_on = [null_resource.aae-registry-htpasswd]
}

resource "aws_s3_bucket" "aae-registry" {
  bucket        = "${var.cluster_name}-registry"
  region        = var.aws_region
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "${var.cluster_name}-registry"
  }
}

