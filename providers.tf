provider "rancher2" {
  version    = "0.2.0-rc5"
  api_url    = "${var.rancher2_url}"
  insecure   = true
  access_key = "${var.rancher2_access_key}"
  secret_key = "${var.rancher2_secret_key}"
}

provider "aws" {
  version = "~> 2.8"
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

provider "null" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "kubernetes" {
  version = "~> 1.6"
}

provider "helm" {
  version      = "~> 0.9"
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.12.3"
  home         = "${path.cwd}/.terraform/helm"
}
