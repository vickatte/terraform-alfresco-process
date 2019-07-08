variable "zone_domain" {
  description = "Zone domain"
}

# settings for AWS Provider
variable "aws_region" {
  description = "AWS region"
}

variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret key"
}

variable "cluster_name" {
  description = "name for your cluster, if not set it will be a concatenation of project_name and project_environment"
}

# APS/AAE Deployment Registry settings
variable "registry_user" {
  description = "username for the deployment docker registry"
}

variable "registry_password" {
  description = "password for the deployment docker registry"
}

variable "registry_host" {
  description = "registry host"
}

variable "helm_service_account" {
  default     = "tiller"
  description = "service account used by helm"
}
