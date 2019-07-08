resource "null_resource" "aps2-registry-upload" {
  triggers = {
    registry_host = "${local.registry_host}"
  }

  provisioner "local-exec" {
    command = "sh -c \"$(curl -fsSL https://git.alfresco.com/process-services-public/alfresco-process-infrastructure-deployment/raw/develop/helm/alfresco-process-infrastructure/upload_images.sh)\""

    environment = {
      QUAY_HOST         = "${var.quay_url}"
      QUAY_USER         = "${var.quay_user}"
      QUAY_PASSWORD     = "${var.quay_password}"
      REGISTRY_HOST     = "${local.registry_host}"
      REGISTRY_USER     = "${var.registry_user}"
      REGISTRY_PASSWORD = "${var.registry_password}"
    }
  }
}
