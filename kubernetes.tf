resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "echo \"$(terraform output kube_config)\" > ${path.cwd}/.terraform/kubeconfig"
  }

  provisioner "local-exec" {
    command = "export KUBECONFIG=${path.cwd}/.terraform/kubeconfig"
  }
}

resource "kubernetes_cluster_role_binding" "tiller-clusterrole-binding" {
  metadata {
    name = "tiller-clusterrole-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "kube-system"
  }

  depends_on = [
    "data.aws_eks_cluster_auth.aps2"
  ]
}

data "kubernetes_service" "nginx-ingress" {
  metadata {
    name = "nginx-ingress-controller"
  }

  depends_on = [
    "helm_release.nginx-ingress"
  ]
}
