provider "null" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "kubernetes" {
  version = "~> 1.7"
}

provider "helm" {
  version         = "~> 0.10"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"
  service_account = "${var.helm_service_account}"
}
