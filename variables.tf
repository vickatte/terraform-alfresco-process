# Rancher2 settings
variable rancher2_url {
  description = "the URL of the Rancher2 server"
}
variable rancher2_access_key {
  description = "Rancher 2 API access key for a user who can create clusters, you can login on Rancher2 and create from the \"API & Keys\" menu on your account or the URL /apikeys"
}
variable rancher2_secret_key {
  description = "Rancher 2 API secret key for a user who can create clusters, you can login on Rancher2 and create from the \"API & Keys\" menu on your account or the URL /apikeys"
}


# AWS Provider settings
variable aws_region {
  description = "AWS region"
}
variable aws_access_key_id {
  description = "AWS access key"
}
variable aws_secret_access_key {
  description = "AWS secret key"
}


# Quay Registry settings
variable quay_url {
  description = "quay url in docker registry format, defaults to \"quay.io\""
  default = "quay.io"
}
variable quay_email {
  description = "quay user email"
}
variable quay_user {
  description = "quay user name"
}
variable quay_password {
  description = "quay user password"
}


# APS/AAE Deployment Registry settings
variable registry_user {
  default = "registry"
  description = "username for the deployment docker registry"
}
variable registry_password {
  default = "password"
  description = "password for the deployment docker registry"
}


# Custom settings for your Rancher Stack
variable project_name {
  description = "project name"
}
variable project_environment {
  description = "project environment like like dev/prod/stagings"
}
variable cluster_name {
  default = ""
  description = "name for your cluster, if not set it will be a concatenation of project_name and project_environment"
}
variable cluster_description {
  default = ""
  description = "description for your cluster"
}


# Kubernetes deployment settings

# API_SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
variable kubernetes_api_server {
  description = "Kubernetes API server URL"
  default = ""
}
## for a generic cluster
# SERVICE_ACCOUNT=default
# NAMESPACE=kube-system
# SECRET_NAME=$(kubectl -n $NAMESPACE get serviceaccount $SERVICE_ACCOUNT -o jsonpath='{.secrets[0].name}')
# TOKEN=$(kubectl -n $NAMESPACE get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode)
## for a rancher cluster
# TOKEN=$(kubectl config view --minify -o jsonpath='{.users[0].user.token}')
variable kubernetes_token {
  description = "Kubernetes API token"
  default = ""
}

# AWS R53 settings
variable aws_zone_domain {
  description = "AWS Route53 zone domain"
}

# APS2/AAE settings
variable aps2_license {
  description = "location of your AAE license file"
}


# ADF app settings
variable adf_app_name {
  default = ""
  description = "extra ADF app to install if set at same path"
}
variable adf_app_image_repository {
  default = "alfresco/demo-shell"
  description = "image of a custom extra ADF app to install"
}
variable adf_app_image_tag {
  default = "latest"
  description = "tag of a custom extra ADF app to install"
}
variable adf_app_image_pull_policy {
  default = "IfNotPresent"
  description = "pull policy of a custom extra ADF app to install"
}
