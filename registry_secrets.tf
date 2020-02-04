locals {
  quaydockercfg = {
    "auths" = {
      "${var.quay_url}" = {
        username   = var.quay_user
        password   = var.quay_password
        email      = "none"
        auth_token = base64encode("${var.quay_user}:${var.quay_password}")
      }
    }
  }
}

resource "kubernetes_secret" "quay-registry-secret" {
  metadata {
    name = "quay-registry-secret"
  }

  data = map(
    ".dockerconfigjson", "${jsonencode(local.quaydockercfg)}"
  )

  type = "kubernetes.io/dockerconfigjson"
}

