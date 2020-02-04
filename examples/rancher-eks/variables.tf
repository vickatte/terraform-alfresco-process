# settings for Rancher2
variable "rancher2_url" {
  description = "the URL of the Rancher2 server"
}

variable "rancher2_access_key" {
  description = "Rancher 2 API access key for a user who can create clusters, you can login on Rancher2 and create from the \"API & Keys\" menu on your account or the URL /apikeys"
}

variable "rancher2_secret_key" {
  description = "Rancher 2 API secret key for a user who can create clusters, you can login on Rancher2 and create from the \"API & Keys\" menu on your account or the URL /apikeys"
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

# settings for your cluster
variable "project_name" {
  description = "project name"
}

variable "project_environment" {
  description = "project environment like dev/prod/stagings"
}

variable "cluster_name" {
  description = "name for your cluster, if not set it will be a concatenation of project_name and project_environment"
}

variable "cluster_description" {
  default     = ""
  description = "description for your cluster"
}

# settings for SSH access to EKS nodes
variable "ssh_username" {
  default     = "aae"
  type        = string
  description = "username to create user on cluster nodes"
}

variable "ssh_public_key" {
  default     = ""
  type        = string
  description = "public key for authentication on cluster nodes"
}

variable "my_ip_address" {
  default     = "0.0.0.0/0"
  description = "CIDR blocks for ssh access to cluster nodes"
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

variable "quay_email" {
  description = "quay user email"
}

variable "zone_domain" {
  description = "Zone domain"
}

# AAE/AAE settings
variable "aae_license" {
  description = "location of your AAE license file"
}

# APS/AAE Deployment Registry settings
variable "registry_host" {
  default     = ""
  description = "deployment docker registry"
}

variable "registry_user" {
  default     = "registry"
  description = "username for the deployment docker registry"
}

variable "registry_password" {
  default     = "password"
  description = "password for the deployment docker registry"
}

variable "gateway_host" {
  default     = ""
  description = "gateway host"
}

variable "identity_host" {
  default     = ""
  description = "identity host"
}

variable "kubernetes_token" {
  description = "Kubernetes API token"
  default     = ""
}

variable "kubernetes_api_server" {
  description = "Kubernetes API server URL"
  default     = "https://kubernetes"
}

# ACS settings
variable "acs_enabled" {
  default     = true
  description = "install Alfresco Content Services as part of the Alfresco Process Infrastructure"
}

