#!/usr/bin/env bash

cd $PWD/examples/rancher-eks/
export KUBECONFIG=/home/travis/build/Alfresco/terraform-alfresco-process/examples/rancher-eks/.terraform/kubeconfig
export K8S_API_URL=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$TF_VAR_cluster_name\")].cluster.server}")
terraform init
terraform refresh
helm ls --all --short | xargs -L1 helm delete --purge
terraform destroy --force