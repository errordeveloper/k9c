#!/usr/bin/env sh

# TODO: add condition to disable this
export PATH=/google-cloud-sdk/bin:$PATH

gcloud config set core/disable_usage_reporting true
gcloud config set component_manager/disable_update_check true
gcloud config set metrics/environment github_docker_image

git config --global credential.helper gcloud.sh
git config --global user.email "dx+training@weave.works"
git config --global user.name "k8s fan"
