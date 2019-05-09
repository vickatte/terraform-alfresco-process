locals {
  quaydockercfg = {
    "auths" = {
      "${var.quay_url}" = {
        username   = "${var.quay_user}"
        password   = "${var.quay_password}"
        email      = "${var.quay_email}"
        auth_token = "${base64encode("${var.quay_user}:${var.quay_password}")}"
      }
    }
  }
}

resource "kubernetes_secret" "quay-registry-secret" {
  metadata {
    name = "quay-registry-secret"
  }

  data {
    ".dockerconfigjson" = "${jsonencode(local.quaydockercfg)}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

locals {
  aps2dockercfg = {
    "auths" = {
      "${local.registry_host}" = {
        username   = "${local.registry_user}"
        password   = "${local.registry_password}"
        email      = "${local.registry_email}"
        auth_token = "${base64encode("${local.registry_user}:${local.registry_password}")}"
      }
    }
  }
}

resource "kubernetes_secret" "aps2-registry-secret" {
  metadata {
    name = "aps2-registry-secret"
  }

  data {
    ".dockerconfigjson" = "${jsonencode(local.aps2dockercfg)}"
  }

  type = "kubernetes.io/dockerconfigjson"
}
