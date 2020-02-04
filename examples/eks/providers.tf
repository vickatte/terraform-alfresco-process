provider "aws" {
  version    = "~> 2.17"
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

provider "helm" {
  version         = "~> 0.10"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"
  service_account = "tiller"
}

