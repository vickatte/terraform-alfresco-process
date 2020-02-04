provider "helm" {
  version         = "0.10.0"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.12.3"
  service_account = "tiller"
}

