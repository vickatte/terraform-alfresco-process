resource "kubernetes_secret" "aps2-license" {
  metadata {
    name = "licenseaps"
  }

  data = "${map(
    "activiti.lic", "${file(var.aps2_license)}"
  )}"
}
