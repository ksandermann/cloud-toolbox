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

########BASE########
echo "Starting with base versions contained in versions base and complete...."
echo "Updating Docker version"
DOCKER_VERSION=$(github_get_latest_release "moby/moby")
replace_version_in_args_file "DOCKER_VERSION" $DOCKER_VERSION "args_base.args"

echo "Updating Kubectl version"
KUBECTL_VERSION=$(github_get_latest_release "kubernetes/kubernetes")
replace_version_in_args_file "KUBECTL_VERSION" $KUBECTL_VERSION "args_base.args"

echo "Updating Helm version"
HELM_VERSION=$(github_get_latest_release "helm/helm")
replace_version_in_args_file "HELM_VERSION" $HELM_VERSION "args_base.args"

echo "Updating Terraform version"
TERRAFORM_VERSION=$(github_get_latest_release "hashicorp/terraform")
replace_version_in_args_file "TERRAFORM_VERSION" $TERRAFORM_VERSION "args_base.args"

echo "Updating Azure-CLI version"
AZ_CLI_VERSION=$(pypi_get_latest_release "azure-cli")
replace_version_in_args_file "AZ_CLI_VERSION" $AZ_CLI_VERSION "args_base.args"

echo "Updating OpenSSH version"
OPENSSH_MAJOR_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" | jq -r '.[0].name' | awk '{print substr($0,3,1)}')
OPENSSH_MINOR_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" | jq -r '.[0].name' | awk '{print substr($0,5,1)}')
OPENSSH_PATCH_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" | jq -r '.[0].name' | awk '{print substr($0,8,1)}')
OPENSSH_VERSION="${OPENSSH_MAJOR_VERSION}.${OPENSSH_MINOR_VERSION}p${OPENSSH_PATCH_VERSION}"
replace_version_in_args_file "OPENSSH_VERSION" $OPENSSH_VERSION "args_base.args"

echo "Updating CRICTL version"
CRICTL_VERSION=$(github_get_latest_release "kubernetes-sigs/cri-tools")
replace_version_in_args_file "CRICTL_VERSION" $CRICTL_VERSION "args_base.args"

echo "Updating Velero version"
VELERO_VERSION=$(github_get_latest_release "vmware-tanzu/velero")
replace_version_in_args_file "VELERO_VERSION" $VELERO_VERSION "args_base.args"

echo "Updating Terraform Sentinel version"
SENTINEL_VERSION=$(curl -sS "https://api.releases.hashicorp.com/v1/releases/sentinel/latest" | jq -r '.version')
replace_version_in_args_file "SENTINEL_VERSION" $SENTINEL_VERSION "args_base.args"

echo "Updating Stern version"
STERN_VERSION=$(github_get_latest_release "stern/stern")
replace_version_in_args_file "STERN_VERSION" $STERN_VERSION "args_base.args"

echo "Updating Kubelogin version"
KUBELOGIN_VERSION=$(github_get_latest_release "Azure/kubelogin")
replace_version_in_args_file "KUBELOGIN_VERSION" $KUBELOGIN_VERSION "args_base.args"


########OPTIONAL########
echo "Starting with optional versions contained in version complete...."
echo "Updating AWS-CLI version"
AWS_CLI_VERSION=$(pypi_get_latest_release "awscli")
replace_version_in_args_file "AWS_CLI_VERSION" $AWS_CLI_VERSION "args_optional.args"

echo "Updating Ansible version"
ANSIBLE_VERSION=$(pypi_get_latest_release_remove_rcs "ansible")
replace_version_in_args_file "ANSIBLE_VERSION" $ANSIBLE_VERSION "args_optional.args"

echo "Updating Jinja version"
JINJA_VERSION=$(pypi_get_latest_release "Jinja2")
replace_version_in_args_file "JINJA_VERSION" $JINJA_VERSION "args_optional.args"

echo "Updating Vault version"
VAULT_VERSION=$(github_get_latest_release "hashicorp/vault")
replace_version_in_args_file "VAULT_VERSION" $VAULT_VERSION "args_optional.args"

echo "Updating README.MD & build.sh"
RELEASE_DATE=$(date --rfc-3339=date)

replace_version_in_args_file "latest" "${RELEASE_DATE}_base" "README.md"
replace_version_in_args_file "project" "${RELEASE_DATE}_base" "README.md"
replace_version_in_args_file "complete" "${RELEASE_DATE}_complete" "README.md"

replace_version_in_args_file "IMAGE_TAG" "\"${RELEASE_DATE}\"" "build.sh"

#TODO
#https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/
OC_CLI_VERSION=1
#https://console.cloud.google.com/storage/browser/cloud-sdk-release;tab=objects
GCLOUD_VERSION=1
