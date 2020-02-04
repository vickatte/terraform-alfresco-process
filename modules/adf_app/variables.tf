# cluster settings

variable "gateway_host" {
  description = "gateway host"
}

variable "cluster_domain" {
  description = "cluster domain"
}

variable "identity_host" {
  description = "identity host"
}

# ADF app settings
variable "adf_app_name" {
  default     = ""
  description = "extra ADF app to install if set at same path"
}

variable "adf_app_image_repository" {
  default     = "alfresco/demo-shell"
  description = "image of a custom extra ADF app to install"
}

variable "adf_app_image_tag" {
  default     = "latest"
  description = "tag of a custom extra ADF app to install"
}

variable "adf_app_image_pull_policy" {
  default     = "IfNotPresent"
  description = "pull policy of a custom extra ADF app to install"
}

