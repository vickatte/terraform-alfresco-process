variable "gateway_host" {
  description = "gateway host"
}

variable "identity_host" {
  description = "identity host"
}

variable "registry_host" {
  description = "registry host"
}

variable "zone_domain" {
  description = "Zone domain"
}

variable "cluster_domain" {
  description = "cluster domain"
}

variable "cluster_name" {
  description = "name for your cluster, if not set it will be a concatenation of project_name and project_environment"
}

variable "helm_service_account" {
  default     = "tiller"
  description = "service account used by helm"
}
