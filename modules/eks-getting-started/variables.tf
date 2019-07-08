#
# Variables Configuration
#

variable "cluster_name" {
  default = "terraform-eks-cluster"
  type    = "string"
}

variable "kubernetes_version" {
  default = ""
  type    = "string"
}

variable "instance_type" {
  default = "m4.large"
  type    = "string"
}
