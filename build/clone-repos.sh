#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

source "/etc/profile.d/gcloud-git.sh"

repos=($(echo "${1}" | jq -c '.[]'))

for repo in "${repos[@]}" ; do
  repo_url="$(echo "${repo}" | jq -r '.repo_url')"
  checkout_path="$(echo "${repo}" | jq -r '.checkout_path')"
  test -d "${checkout_path}" \
    || git clone "${repo_url}" "${checkout_path}"
done
