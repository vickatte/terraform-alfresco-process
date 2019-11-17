resource "kubernetes_secret" "aae-license" {
  metadata {
    name = "licenseaps"
  }

  data = "${map(
    "activiti.lic", "${file(var.aae_license)}"
  )}"
}
