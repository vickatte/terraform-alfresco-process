provider "rancher2" {
  version    = "~> 1.0"
  api_url    = "${var.rancher2_url}"
  insecure   = true
  access_key = "${var.rancher2_access_key}"
  secret_key = "${var.rancher2_secret_key}"
}

provider "aws" {
  version    = "~> 2.17"
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

provider "template" {
  version = "~> 2.1"
}

provider "helm" {
  version         = "~> 0.10"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"
  service_account = "tiller"
}
