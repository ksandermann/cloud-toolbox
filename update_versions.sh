#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

declare -A grouped_changes
log_change() {
  local file="$1"
  local msg="$2"
  grouped_changes["$file"]+="$msg"$'\n'
}

echo "Updating README.MD & build.sh"
RELEASE_DATE=$(date --rfc-3339=date)

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

replace_version_in_args_file() {
  local key="$1"
  local new_version="$2"
  local file="$3"

  echo "Replacing $key with $new_version in $file"

  if grep -q "^${key}=" "$file"; then
    local current_version
    current_version=$(grep "^${key}=" "$file" | cut -d'=' -f2-)

    if [[ "$current_version" != "$new_version" ]]; then
      sed -i "s|^${key}=.*|${key}=${new_version}|" "$file"
      log_change "$file" "- $key updated from $current_version to $new_version"
    fi
  else
    echo "${key}=${new_version}" >> "$file"
    log_change "$file" "- $key added with value $new_version"
  fi
}

pypi_get_latest_release() {
  curl -s "https://pypi.org/pypi/$1/json" | jq -r '.releases | keys | .[]' | sort -V | tail -n 1
}

mkdir -p releases
RELEASE_NOTES_FILE="releases/${RELEASE_DATE}.md"

{
  echo "${RELEASE_DATE}"
  echo ""
  echo "Changelog"
} > "${RELEASE_NOTES_FILE}"

echo "Release notes created at ${RELEASE_NOTES_FILE}"

fetch_latest_gcloud_version() {
  curl -sL "https://cloud.google.com/sdk/docs/release-notes" \
    | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' \
    | sort -V | tail -1
}

########BASE########
echo "Starting with base versions contained in versions base and complete...."

UBUNTU_VERSION="22.04"
# Manually set base image version ubuntu
replace_version_in_args_file "UBUNTU_VERSION" $UBUNTU_VERSION "args_base.args"

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
#AZ_CLI_VERSION=$(pypi_get_latest_release "azure-cli")
AZ_CLI_VERSION="2.72.0"
replace_version_in_args_file "AZ_CLI_VERSION" $AZ_CLI_VERSION "args_base.args"

OPENSSH_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" \
  | jq -r '.[0].name' \
  | sed -E 's/^V_([0-9]+)_([0-9]+)(_P([0-9]+))?$/\1.\2p\4/' \
  | sed 's/p$//')  # handles missing patch

replace_version_in_args_file "OPENSSH_VERSION" "$OPENSSH_VERSION" "args_base.args"

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
#KUBELOGIN_VERSION=$(github_get_latest_release "Azure/kubelogin")
KUBELOGIN_VERSION="0.1.9"
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

replace_version_in_args_file "latest" "${RELEASE_DATE}_base" "README.md"
replace_version_in_args_file "project" "${RELEASE_DATE}_base" "README.md"
replace_version_in_args_file "complete" "${RELEASE_DATE}_complete" "README.md"

replace_version_in_args_file "IMAGE_TAG" "\"${RELEASE_DATE}\"" "build.sh"

OC_CLI_VERSION=$(curl -s https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ | grep -o 'openshift-client-linux-[0-9]*\.[0-9]*\.[0-9]*\.tar\.gz' | sort -V | tail -1 | sed 's/openshift-client-linux-\([0-9]*\.[0-9]*\.[0-9]*\)\.tar\.gz/\1/')
replace_version_in_args_file "OC_CLI_VERSION" $OC_CLI_VERSION "args_optional.args"

GCLOUD_VERSION=$(fetch_latest_gcloud_version)
replace_version_in_args_file "GCLOUD_VERSION" "$GCLOUD_VERSION" "args_optional.args"

if [[ ${#grouped_changes[@]} -eq 0 ]]; then
  echo "No version changes detected."
  exit 0
fi

# Write grouped changelog
{
  echo "## 🔄 Version Update Changelog"
  for file in "${!grouped_changes[@]}"; do
    [[ "$file" == "README.md" ]] && continue
    echo ""

    case "$file" in
      args_base.args)
        echo "### 🧱 Base Args (\`$file\`)"
        ;;
      args_optional.args)
        echo "### 🧩 Optional Args (\`$file\`)"
        ;;
      build.sh)
        echo "### 🔧 Build (\`$file\`)"
        ;;
      *)
        echo "### 📁 Other (\`$file\`)"
        ;;
    esac

    while IFS= read -r line; do
      key=$(echo "$line" | cut -d' ' -f1)
      from=$(echo "$line" | grep -oP 'from \K[^ ]+' || echo "unknown")
      to=$(echo "$line" | grep -oP 'to \K[^ ]+' || echo "unknown")
      echo "- \`$key\` updated from \`$from\` → \`$to\`"
    done <<< "${grouped_changes[$file]}"

    echo ""
  done
} > changed_versions.txt

echo "✅ Changelog written to changed_versions.txt"


######## README.md #######
table_start_line=$(awk '/^\| RELEASE / {print NR}' README.md)
offset=1
insert_line=$((table_start_line + offset))

# Construct the new lines with updated versions
new_lines="| ${RELEASE_DATE}_complete | $UBUNTU_VERSION  | $DOCKER_VERSION   | $KUBECTL_VERSION  | $HELM_VERSION | $TERRAFORM_VERSION     | $AZ_CLI_VERSION | $OPENSSH_VERSION   | $CRICTL_VERSION | $VELERO_VERSION | $SENTINEL_VERSION   | $STERN_VERSION | $KUBELOGIN_VERSION     | $OC_CLI_VERSION | $AWS_CLI_VERSION  | $GCLOUD_VERSION    | $ANSIBLE_VERSION   | $JINJA_VERSION  | $VAULT_VERSION |"

sed -i "${insert_line}a\\
${new_lines}" README.md
