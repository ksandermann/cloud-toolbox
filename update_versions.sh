#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

RELEASE_DATE=$(date --rfc-3339=date)
CHANGELOG_FILE="changed_versions.txt"
RELEASE_NOTES_FILE="releases/${RELEASE_DATE}.md"

mkdir -p releases
> "$CHANGELOG_FILE"

log_change() {
  local file="$1"
  local msg="$2"
  echo "- $msg" >> "$CHANGELOG_FILE"
}

github_get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed 's/^v//' || echo ""
}

pypi_get_latest_release_remove_rcs() {
  curl -s "https://pypi.org/pypi/$1/json" | jq -r '.releases | keys | sort_by(.) | reverse | .[]' \
    | grep -Ev 'a|b|rc' | head -n 1 || echo ""
}

pypi_get_latest_release() {
  curl -s "https://pypi.org/pypi/$1/json" | jq -r '.releases | keys | .[]' | sort -V | tail -n 1 || echo ""
}

fetch_latest_gcloud_version() {
  curl -sL "https://cloud.google.com/sdk/docs/release-notes" \
    | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' \
    | sort -V | tail -1 || echo ""
}

replace_version_in_args_file() {
  local key="$1"
  local new_version="$2"
  local file="$3"
  local current_version=""

  if grep -q "^${key}=" "$file"; then
    current_version=$(grep "^${key}=" "$file" | cut -d'=' -f2-)
    if [[ "$current_version" != "$new_version" ]]; then
      sed -i "s|^${key}=.*|${key}=${new_version}|" "$file"
      log_change "$file" "$key updated from $current_version to $new_version"
    fi
  else
    echo "${key}=${new_version}" >> "$file"
    log_change "$file" "$key added with value $new_version"
  fi
}

echo "Updating versions..."

echo "# ${RELEASE_DATE}" > "$RELEASE_NOTES_FILE"
echo "" >> "$RELEASE_NOTES_FILE"
echo "## Changelog" >> "$RELEASE_NOTES_FILE"
echo "" >> "$RELEASE_NOTES_FILE"

# BASE
replace_version_in_args_file "UBUNTU_VERSION" "22.04" "args_base.args"
replace_version_in_args_file "DOCKER_VERSION" "$(github_get_latest_release moby/moby)" "args_base.args"
replace_version_in_args_file "KUBECTL_VERSION" "$(github_get_latest_release kubernetes/kubernetes)" "args_base.args"
replace_version_in_args_file "HELM_VERSION" "$(github_get_latest_release helm/helm)" "args_base.args"
replace_version_in_args_file "TERRAFORM_VERSION" "$(github_get_latest_release hashicorp/terraform)" "args_base.args"
replace_version_in_args_file "AZ_CLI_VERSION" "$(pypi_get_latest_release azure-cli)" "args_base.args"
OPENSSH_VERSION=$(curl -s "https://api.github.com/repos/openssh/openssh-portable/tags" \
  | jq -r '.[0].name' \
  | sed -E 's/^V_([0-9]+)_([0-9]+)(_P([0-9]+))?$/\1.\2p\4/' | sed 's/p$//')
replace_version_in_args_file "OPENSSH_VERSION" "$OPENSSH_VERSION" "args_base.args"
replace_version_in_args_file "CRICTL_VERSION" "$(github_get_latest_release kubernetes-sigs/cri-tools)" "args_base.args"
replace_version_in_args_file "VELERO_VERSION" "$(github_get_latest_release vmware-tanzu/velero)" "args_base.args"
replace_version_in_args_file "SENTINEL_VERSION" "$(curl -s "https://api.releases.hashicorp.com/v1/releases/sentinel/latest" | jq -r .version)" "args_base.args"
replace_version_in_args_file "STERN_VERSION" "$(github_get_latest_release stern/stern)" "args_base.args"
replace_version_in_args_file "KUBELOGIN_VERSION" "0.1.9" "args_base.args"  # pinned

# OPTIONAL
replace_version_in_args_file "AWS_CLI_VERSION" "$(pypi_get_latest_release awscli)" "args_optional.args"
replace_version_in_args_file "ANSIBLE_VERSION" "$(pypi_get_latest_release_remove_rcs ansible)" "args_optional.args"
replace_version_in_args_file "JINJA_VERSION" "$(pypi_get_latest_release Jinja2)" "args_optional.args"
replace_version_in_args_file "VAULT_VERSION" "$(github_get_latest_release hashicorp/vault)" "args_optional.args"

OC_CLI_VERSION=$(curl -s https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ \
  | grep -o 'openshift-client-linux-[0-9]*\.[0-9]*\.[0-9]*\.tar\.gz' \
  | sort -V | tail -1 \
  | sed 's/openshift-client-linux-\([0-9]*\.[0-9]*\.[0-9]*\)\.tar\.gz/\1/')
replace_version_in_args_file "OC_CLI_VERSION" "$OC_CLI_VERSION" "args_optional.args"
replace_version_in_args_file "GCLOUD_VERSION" "$(fetch_latest_gcloud_version)" "args_optional.args"

# README update
sed -i "s/latest=.*/latest=${RELEASE_DATE}_base/" README.md
sed -i "s/project=.*/project=${RELEASE_DATE}_base/" README.md
sed -i "s/complete=.*/complete=${RELEASE_DATE}_complete/" README.md
sed -i "s/IMAGE_TAG=.*/IMAGE_TAG=\"${RELEASE_DATE}\"/" build.sh

# Print final changelog if needed
if [[ -s "$CHANGELOG_FILE" ]]; then
  echo -e "\n### Version Changes:\n"
  cat "$CHANGELOG_FILE" >> "$RELEASE_NOTES_FILE"
else
  echo "No version changes detected."
fi
