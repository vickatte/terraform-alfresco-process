# optional settings for AWS
variable "aws_efs_dns_name" {
  default     = ""
  description = "EFS DNS name to be used for ACS file storage (optional AWS only)"
}

# Quay Registry settings
variable "quay_url" {
  description = "quay url in docker registry format, defaults to \"quay.io\""
  default     = "quay.io"
}

variable "quay_user" {
  description = "quay user name"
}

variable "quay_password" {
  description = "quay user password"
}

# APS/AAE Deployment Registry settings
variable "registry_host" {
  description = "docker registry host name"
}

variable "registry_user" {
  default     = "registry"
  description = "username for the deployment docker registry"
}

variable "registry_password" {
  default     = "password"
  description = "password for the deployment docker registry"
}

# gateway settings
variable "gateway_host" {
  description = "gateway host name"
}

variable "zone_domain" {
  description = "Zone domain"
}

variable "http" {
  default     = "false"
  description = "use http rather than https for urls"
}

# Custom settings for your cluster
variable "project_name" {
  description = "project name"
}

variable "project_environment" {
  description = "project environment like dev/prod/staging"
}

variable "cluster_name" {
  default     = ""
  description = "name for your cluster, if not set it will be a concatenation of project_name and project_environment"
}

# Kubernetes deployment settings
# for same cluster the internal URL is fine otherwise:
# API_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
variable "kubernetes_api_server" {
  description = "Kubernetes API server URL"
  default     = "https://kubernetes"
}

## for a generic cluster
# SERVICE_ACCOUNT=default
# NAMESPACE=kube-system
# SECRET_NAME=$(kubectl -n $NAMESPACE get serviceaccount $SERVICE_ACCOUNT -o jsonpath='{.secrets[0].name}')
# TOKEN=$(kubectl -n $NAMESPACE get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode)
## for a rancher cluster
# TOKEN=$(kubectl config view --minify -o jsonpath='{.users[0].user.token}')
variable "kubernetes_token" {
  description = "Kubernetes API token"
  default     = ""
}

# APS2/AAE settings
variable "aps2_license" {
  description = "location of your AAE license file"
}

# ACS settings
variable "acs_enabled" {
  default     = true
  description = "install Alfresco Content Services as part of the Alfresco Process Infrastructure"
}

variable "helm_service_account" {
  default     = "tiller"
  description = "service account used by helm"
}
