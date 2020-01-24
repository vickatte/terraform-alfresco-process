#!/usr/bin/env bash

cd $PWD/examples/rancher-eks/
terraform init
echo yes | terraform apply -target=rancher2_cluster.aae-cluster
export KUBECONFIG=$PWD/.terraform/kubeconfig
echo "$(terraform output kube_config)" > $KUBECONFIG
kubectl cluster-info
export NAMESPACE=kube-system &&
export SERVICEACCOUNT=alfresco-deployment-service
kubectl create serviceaccount -n kube-system ${SERVICEACCOUNT} &&
  kubectl create clusterrolebinding ${SERVICEACCOUNT}-admin-binding --clusterrole cluster-admin --serviceaccount=${NAMESPACE}:${SERVICEACCOUNT}
echo "kubernetes_token = \"$(kubectl -n ${NAMESPACE} get secret $(kubectl -n ${NAMESPACE} get serviceaccount ${SERVICEACCOUNT} -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode)\"" >> terraform.tfvars
echo yes | terraform apply
