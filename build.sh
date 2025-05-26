#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

RELEASE_DATE=$(date --rfc-3339=date)

# Array to track changed versions
changed_versions=()

# Utility functions
github_get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed 's/^v//'
}

pypi_get_latest_release_remove_rcs() {
  RETURNEDLIST=$(curl -s "https://pypi.org/pypi/$1/json" | jq -r '.releases | keys | sort_by(.) | reverse | .[]')
  for version in $RETURNEDLIST; do
    if [[ "$version" != *"rc"* && "$version" != *"b"* && "$version" != *"a"* ]]; then
      echo $version
      break
    fi
  done
}

pypi_get_latest_release() {
  curl -s "https://pypi.org/pypi/$1/json" | jq -r '.releases | keys | .[]' | sort -V | tail -n 1
}

fetch_latest_gcloud_version() {
  html_content=$(curl -sL "https://cloud.google.com/sdk/docs/release-notes")
  echo "$html_content" | grep -oE '\b[0-9]+\.[0-9]+\.[0-9]+\b' | sort -V | tail -1
}

replace_version_in_args_file() {
  local key="$1"
  local new_version="$2"
  local file="$3"

  if grep -q "^${key}=" "$file"; then
    old_version=$(grep "^${key}=" "$file" | cut -d'=' -f2)
    if [[ "$old_version" != "$new_version" ]]; then
      sed -i "s|^${key}=.*|${key}=${new_version}|" "$file"
      changed_versions+=("${key} updated from ${old_version} to ${new_version}")
    fi
  fi
}

mkdir -p releases
RELEASE_NOTES_FILE="releases/${RELEASE_DATE}.md"

######## BASE ########
echo "Starting with base versions contained in versions base and complete...."

UBUNTU_VERSION="22.04"
replace_version_in_args_file "UBUNTU_VERSION" "$UBUNTU_VERSION" "args_base.args"

DOCKER_VERSION=$(github_get_latest_release "moby/moby")
replace_version_in_args_file "DOCKER_VERSION" "$DOCKER_VERSION" "args_base.args"

KUBECTL_VERSION=$(github_get_latest_release "kubernetes/kubernetes")
replace_version_in_args_file "KUBECTL_VERSION" "$KUBECTL_VERSION" "args_base.args"

HELM_VERSION=$(github_get_latest_release "helm/helm")
replace_version_in_args_file "HELM_VERSION" "$HELM_VERSION" "args_base.args"

TERRAFORM_VERSION=$(github_get_latest_release "hashicorp/terraform")
replace_version_in_args_file "TERRAFORM_VERSION" "$TERRAFORM_VERSION" "args_base.args"

AZ_CLI_VERSION=$(pypi_get_latest_release "azure-cli")
replace_version_in_args_file "AZ_CLI_VERSION" "$AZ_CLI_VERSION" "args_base.args"

OPENSSH_VERSION="10.0p2"
replace_version_in_args_file "OPENSSH_VERSION" "$OPENSSH_VERSION" "args_base.args"

CRICTL_VERSION=$(github_get_latest_release "kubernetes-sigs/cri-tools")
replace_version_in_args_file "CRICTL_VERSION" "$CRICTL_VERSION" "args_base.args"

VELERO_VERSION=$(github_get_latest_release "vmware-tanzu/velero")
replace_version_in_args_file "VELERO_VERSION" "$VELERO_VERSION" "args_base.args"

SENTINEL_VERSION=$(curl -sS "https://api.releases.hashicorp.com/v1/releases/sentinel/latest" | jq -r '.version')
replace_version_in_args_file "SENTINEL_VERSION" "$SENTINEL_VERSION" "args_base.args"

STERN_VERSION=$(github_get_latest_release "stern/stern")
replace_version_in_args_file "STERN_VERSION" "$STERN_VERSION" "args_base.args"

KUBELOGIN_VERSION=$(github_get_latest_release "Azure/kubelogin")
replace_version_in_args_file "KUBELOGIN_VERSION" "$KUBELOGIN_VERSION" "args_base.args"

######## OPTIONAL ########
echo "Starting with optional versions contained in version complete...."

AWS_CLI_VERSION=$(pypi_get_latest_release "awscli")
replace_version_in_args_file "AWS_CLI_VERSION" "$AWS_CLI_VERSION" "args_optional.args"

ANSIBLE_VERSION=$(pypi_get_latest_release_remove_rcs "ansible")
replace_version_in_args_file "ANSIBLE_VERSION" "$ANSIBLE_VERSION" "args_optional.args"

JINJA_VERSION=$(pypi_get_latest_release "Jinja2")
replace_version_in_args_file "JINJA_VERSION" "$JINJA_VERSION" "args_optional.args"

VAULT_VERSION=$(github_get_latest_release "hashicorp/vault")
replace_version_in_args_file "VAULT_VERSION" "$VAULT_VERSION" "args_optional.args"

replace_version_in_args_file "latest" "${RELEASE_DATE}_base" "README.md"
replace_version_in_args_file "project" "${RELEASE_DATE}_base" "README.md"
replace_version_in_args_file "complete" "${RELEASE_DATE}_complete" "README.md"

replace_version_in_args_file "IMAGE_TAG" "\"${RELEASE_DATE}\"" "build.sh"

OC_CLI_VERSION=$(curl -s https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ | grep -o 'openshift-client-linux-[0-9]*\.[0-9]*\.[0-9]*\.tar\.gz' | sort -V | tail -1 | sed 's/openshift-client-linux-\([0-9]*\.[0-9]*\.[0-9]*\)\.tar\.gz/\1/')
replace_version_in_args_file "OC_CLI_VERSION" "$OC_CLI_VERSION" "args_optional.args"

GCLOUD_VERSION=$(fetch_latest_gcloud_version)
replace_version_in_args_file "GCLOUD_VERSION" "$GCLOUD_VERSION" "args_optional.args"

######## README Update Table ########
table_start_line=$(awk '/^\| RELEASE / {print NR}' README.md)
offset=1
insert_line=$((table_start_line + offset))

new_lines="| ${RELEASE_DATE}_complete | $UBUNTU_VERSION  | $DOCKER_VERSION   | $KUBECTL_VERSION  | $HELM_VERSION | $TERRAFORM_VERSION     | $AZ_CLI_VERSION | $OPENSSH_VERSION   | $CRICTL_VERSION | $VELERO_VERSION | $SENTINEL_VERSION   | $STERN_VERSION | $KUBELOGIN_VERSION     | $OC_CLI_VERSION | $AWS_CLI_VERSION  | $GCLOUD_VERSION    | $ANSIBLE_VERSION   | $JINJA_VERSION  | $VAULT_VERSION |"

sed -i "${insert_line}a\\
${new_lines}" README.md

######## Changelog Output ########
if [[ ${#changed_versions[@]} -eq 0 ]]; then
  echo "No version changes detected."
  exit 0
fi

{
  echo "Changelog"
  echo ""
  echo "Version updates:"
  echo ""
  for line in "${changed_versions[@]}"; do
    key=$(echo "$line" | awk '{print $1}' | sed 's/_VERSION//' | tr '[:upper:]' '[:lower:]')
    from=$(echo "$line" | awk '{for (i=1; i<=NF; i++) if ($i == "from") print $(i+1)}')
    to=$(echo "$line" | awk '{for (i=1; i<=NF; i++) if ($i == "to") print $(i+1)}')
    if [[ -n "$key" && -n "$from" && -n "$to" ]]; then
      echo "$key from $from → $to"
    fi
  done
} > changed_versions.txt

echo "✅ Changelog written to changed_versions.txt"IMAGE_TAG="2025-05-26"
