data "aws_eks_cluster" "aps2-cluster" {
  name = "${local.cluster_name}"

  depends_on = [
    "null_resource.kubeconfig",
  ]
}

module "helm" {
  source = "../../modules/helm"
}

module "ingress" {
  source = "../../modules/ingress_aws"

  gateway_host   = "${local.gateway_host}"
  cluster_domain = "${local.cluster_domain}"
  identity_host  = "${local.identity_host}"
  registry_host  = "${local.registry_host}"
  zone_domain    = "${var.zone_domain}"
  cluster_name   = "${data.aws_eks_cluster.aps2-cluster.name}"

  helm_service_account = "${module.helm.service_account}"
}

# Install Docker Regisry on AWS
module "docker_registry" {
  source = "../../modules/docker_registry_aws"

  zone_domain = "${var.zone_domain}"

  aws_region            = "${var.aws_region}"
  aws_access_key_id     = "${var.aws_access_key_id}"
  aws_secret_access_key = "${var.aws_secret_access_key}"

  cluster_name = "${local.cluster_name}"

  registry_user     = "${var.registry_user}"
  registry_password = "${var.registry_password}"

  registry_host = "${module.ingress.registry_host}"

  helm_service_account = "${module.helm.service_account}"
}

module "aws_efs" {
  source = "../../modules/aws_efs"

  cluster_name = "${data.aws_eks_cluster.aps2-cluster.name}"
}

# Install Alfresco Activiti Enterprise on
module "alfresco-process-services" {
  source = "../.."

  aps2_license = "${var.aps2_license}"

  zone_domain = "${var.zone_domain}"

  aws_efs_dns_name = "${module.aws_efs.aws_efs_dns_name}"

  quay_user     = "${var.quay_user}"
  quay_password = "${var.quay_password}"

  project_environment = "${var.project_environment}"
  project_name        = "${var.project_name}"
  cluster_name        = "${local.cluster_name}"
  registry_host       = "${module.docker_registry.registry_host}"
  gateway_host        = "${module.ingress.gateway_host}"

  helm_service_account = "${module.helm.service_account}"

  kubernetes_token      = "${var.kubernetes_token}"
  kubernetes_api_server = "${var.kubernetes_api_server}"

  acs_enabled = "${var.acs_enabled}"
}
