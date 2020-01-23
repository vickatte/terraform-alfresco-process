#!/usr/bin/env bash

cd $PWD/examples/rancher-eks/
aws s3 sync s3://$CACHE_BUCKET/$TRAVIS_BUILD_NUMBER/ .
export KUBECONFIG=$PWD/.terraform/kubeconfig
export K8S_API_URL=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$TF_VAR_cluster_name\")].cluster.server}")
