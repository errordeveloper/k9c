#!/usr/bin/env sh

# add a way to disable the gcloud
export PATH=/google-cloud-sdk/bin:$PATH
git config --global credential.helper gcloud.sh
git config --global user.email "dx+training@weave.works"
git config --global user.name "k8s fan"

