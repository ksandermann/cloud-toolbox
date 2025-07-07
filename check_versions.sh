#!/bin/sh
set -e

echo "🔍 Comparing pinned vs latest versions..."

# Helper to extract pinned version from args files
get_pinned_version() {
  grep -E "^$1=" args_base.args args_optional.args 2>/dev/null | head -n1 | cut -d'=' -f2 | tr -d '"'
}

# === Fetch functions ===
github_latest() {
  curl -s "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | head -1 | cut -d'"' -f4 | sed 's/^v//'
}

pypi_latest() {
  curl -s "https://pypi.org/pypi/$1/json" | grep -o '"version": *"[^"]*"' | head -1 | cut -d'"' -f4
}

pypi_latest_no_rc() {
  curl -s "https://pypi.org/pypi/$1/json" | grep -oE '"[0-9]+\.[0-9]+\.[0-9]+"' | grep -vE '(rc|a|b)' | sort -V | tail -1 | tr -d '"'
}

fetch_oc_cli() {
  curl -s https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ |
    grep -o 'openshift-client-linux-[0-9]*\.[0-9]*\.[0-9]*\.tar\.gz' |
    sort -V | tail -1 |
    sed 's/openshift-client-linux-\(.*\)\.tar\.gz/\1/'
}

fetch_gcloud() {
  curl -sL "https://cloud.google.com/sdk/docs/release-notes" |
    grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' |
    sort -V | tail -1
}

fetch_openssh() {
  curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" |
    grep '"name":' | head -1 | sed -E 's/.*"V_([0-9]+)_([0-9]+)(_P([0-9]+))?".*/\1.\2p\4/' | sed 's/p$//'
}

# === Tools and logic ===
compare_tool() {
  TOOL=$1
  LATEST=$2
  PINNED=$(get_pinned_version "$TOOL")

  if [ -z "$PINNED" ]; then
    echo "$TOOL: not pinned, latest=$LATEST"
  elif [ "$PINNED" = "$LATEST" ]; then
    echo "$TOOL: pinned=$PINNED ✅"
  else
    echo "$TOOL: pinned=$PINNED, latest=$LATEST ⬆️"
  fi
}

compare_tool OC_CLI_VERSION "$(fetch_oc_cli)"
compare_tool AWS_CLI_VERSION "$(pypi_latest awscli)"
compare_tool GCLOUD_VERSION "$(fetch_gcloud)"
compare_tool ANSIBLE_VERSION "$(pypi_latest_no_rc ansible)"
compare_tool JINJA_VERSION "$(pypi_latest Jinja2)"
compare_tool VAULT_VERSION "$(github_latest hashicorp/vault)"
compare_tool UBUNTU_VERSION "22.04"
compare_tool DOCKER_VERSION "$(github_latest moby/moby)"
compare_tool KUBECTL_VERSION "$(github_latest kubernetes/kubernetes)"
compare_tool HELM_VERSION "$(github_latest helm/helm)"
compare_tool TERRAFORM_VERSION "$(github_latest hashicorp/terraform)"
compare_tool AZ_CLI_VERSION "$(pypi_latest azure-cli)"
compare_tool OPENSSH_VERSION "$(fetch_openssh)"
compare_tool CRICTL_VERSION "$(github_latest kubernetes-sigs/cri-tools)"
compare_tool VELERO_VERSION "$(github_latest vmware-tanzu/velero)"
compare_tool SENTINEL_VERSION "$(curl -s https://api.releases.hashicorp.com/v1/releases/sentinel/latest | grep version | cut -d'"' -f4)"
compare_tool STERN_VERSION "$(github_latest stern/stern)"
compare_tool KUBELOGIN_VERSION "$(github_latest Azure/kubelogin)"