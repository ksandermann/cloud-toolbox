#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#This script only works on Linux, not on MacOs. On MacOS, run it inside the toolbox itself.

github_get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed 's/v//g'
}

pypi_get_latest_release_remove_rcs() {
  #get all releases by they keys(=version number) in order, starting with the highest release
  RETURNEDLIST=$(curl -s "https://pypi.org/pypi/$1/json" | jq -r '.releases | keys | sort_by(.) | reverse | .[]')
  #go through all releases and echo/return the first which does not alpha/beta/rc identifiers, then break loop
  for version in $RETURNEDLIST
  do
    if [[ "${version}" != *"rc"* && "${version}" != *"b"* && "${version}" != *"a"* ]];
      then
        echo $version
        break
    fi
  done
}

pypi_get_latest_release() {
  curl -s "https://pypi.org/pypi/$1/json" | jq -r '.releases | keys | .[]' | sort -V | tail -n 1
}

replace_version_in_args_file() {
  sed -i "s/$1=.*/$1=$2/g" $3
}

DOCKER_VERSION=$(github_get_latest_release "moby/moby")
replace_version_in_args_file "DOCKER_VERSION" $DOCKER_VERSION "args_base.args"

KUBECTL_VERSION=$(github_get_latest_release "kubernetes/kubernetes")
replace_version_in_args_file "KUBECTL_VERSION" $KUBECTL_VERSION "args_base.args"

HELM_VERSION=$(github_get_latest_release "helm/helm")
replace_version_in_args_file "HELM_VERSION" $HELM_VERSION "args_base.args"

TERRAFORM_VERSION=$(github_get_latest_release "hashicorp/terraform")
replace_version_in_args_file "TERRAFORM_VERSION" $TERRAFORM_VERSION "args_base.args"

AZ_CLI_VERSION=$(pypi_get_latest_release "azure-cli")
replace_version_in_args_file "AZ_CLI_VERSION" $AZ_CLI_VERSION "args_base.args"

CRICTL_VERSION=$(github_get_latest_release "kubernetes-sigs/cri-tools")
replace_version_in_args_file "CRICTL_VERSION" $CRICTL_VERSION "args_base.args"

VELERO_VERSION=$(github_get_latest_release "vmware-tanzu/velero")
replace_version_in_args_file "VELERO_VERSION" $VELERO_VERSION "args_base.args"

STERN_VERSION=$(github_get_latest_release "stern/stern")
replace_version_in_args_file "STERN_VERSION" $STERN_VERSION "args_base.args"

KUBELOGIN_VERSION=$(github_get_latest_release "Azure/kubelogin")
replace_version_in_args_file "KUBELOGIN_VERSION" $KUBELOGIN_VERSION "args_base.args"


OPENSSH_MAJOR_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" | jq -r '.[0].name' | awk '{print substr($0,3,1)}')
OPENSSH_MINOR_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" | jq -r '.[0].name' | awk '{print substr($0,5,1)}')
OPENSSH_PATCH_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" | jq -r '.[0].name' | awk '{print substr($0,8,1)}')
OPENSSH_VERSION="${OPENSSH_MAJOR_VERSION}.${OPENSSH_MINOR_VERSION}p${OPENSSH_PATCH_VERSION}"
replace_version_in_args_file "OPENSSH_VERSION" $OPENSSH_VERSION "args_base.args"

SENTINEL_VERSION=$(curl -sS "https://api.releases.hashicorp.com/v1/releases/sentinel/latest" | jq -r '.version')
replace_version_in_args_file "SENTINEL_VERSION" $SENTINEL_VERSION "args_base.args"


AWS_CLI_VERSION=$(pypi_get_latest_release "awscli")
replace_version_in_args_file "AWS_CLI_VERSION" $AWS_CLI_VERSION "args_optional.args"

ANSIBLE_VERSION=$(pypi_get_latest_release_remove_rcs "ansible")
replace_version_in_args_file "ANSIBLE_VERSION" $ANSIBLE_VERSION "args_optional.args"

JINJA_VERSION=$(pypi_get_latest_release "Jinja2")
replace_version_in_args_file "JINJA_VERSION" $JINJA_VERSION "args_optional.args"

VAULT_VERSION=$(github_get_latest_release "hashicorp/vault")
replace_version_in_args_file "VAULT_VERSION" $VAULT_VERSION "args_optional.args"



#https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/
OC_CLI_VERSION=4.11.13
#https://console.cloud.google.com/storage/browser/cloud-sdk-release;tab=objects
GCLOUD_VERSION=410.0.0-0

