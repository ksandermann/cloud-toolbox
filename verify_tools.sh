#!/usr/bin/env bash
# Verifies that every tool pinned in the args files is installed in the running
# image and reports a version that matches the pin.
#
# Usage:
#   MODE=base     bash verify_tools.sh   # checks args_base.args only
#   MODE=complete bash verify_tools.sh   # checks args_base.args + args_optional.args
#
# Exits non-zero if any tool is missing or its version does not match the pin.

set -uo pipefail

MODE="${MODE:-complete}"

ARGS_FILES=("args_base.args")
if [[ "$MODE" == "complete" ]]; then
  ARGS_FILES+=("args_optional.args")
fi

declare -A PIN
for f in "${ARGS_FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "fatal: $f not found in $(pwd)"
    exit 2
  fi
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    PIN["${line%%=*}"]="${line#*=}"
  done < "$f"
done

PASS=0
MISMATCH=0
MISSING=0

check() {
  local key="$1" tool="$2" cmd="$3"
  local expected="${PIN[$key]:-}"
  [[ -z "$expected" ]] && return 0

  if ! command -v "$tool" >/dev/null 2>&1; then
    printf '❌ %-25s pin=%-15s — "%s" not found on PATH\n' "$key" "$expected" "$tool"
    MISSING=$((MISSING + 1))
    return
  fi

  local out
  if ! out=$(eval "$cmd" 2>&1); then
    printf '❌ %-25s pin=%-15s — command failed: %s\n' "$key" "$expected" "$cmd"
    printf '   %s\n' "$(head -n1 <<<"$out")"
    MISMATCH=$((MISMATCH + 1))
    return
  fi

  if grep -Fq "$expected" <<<"$out"; then
    printf '✅ %-25s pin=%-15s (%s)\n' "$key" "$expected" "$tool"
    PASS=$((PASS + 1))
  else
    printf '⚠️  %-25s pin=%-15s — installed but version not found in output:\n' "$key" "$expected"
    printf '   %s\n' "$(head -n1 <<<"$out")"
    MISMATCH=$((MISMATCH + 1))
  fi
}

echo "🔍 Verifying pinned tools (mode=$MODE, arch=$(uname -m))"
echo

# Base tools
check DOCKER_VERSION     docker     "docker --version"
check KUBECTL_VERSION    kubectl    "kubectl version --client=true"
check HELM_VERSION       helm       "helm version --short"
check TERRAFORM_VERSION  terraform  "terraform version"
check AZ_CLI_VERSION     az         "az version --output tsv"
check OPENSSH_VERSION    ssh        "dpkg-query -W -f='\${Version}\n' openssh-client"
check CRICTL_VERSION     crictl     "crictl --version"
check VELERO_VERSION     velero     "velero version --client-only"
check SENTINEL_VERSION   sentinel   "sentinel --version"
check STERN_VERSION      stern      "stern --version"
check KUBELOGIN_VERSION  kubelogin  "kubelogin --version"
check ZSH_VERSION        zsh        "dpkg-query -W -f='\${Version}\n' zsh"

# Optional tools (silently skipped when MODE=base since pins won't be set)
check OC_CLI_VERSION     oc         "oc version --client"
check AWS_CLI_VERSION    aws        "aws --version"
check GCLOUD_VERSION     gcloud     "dpkg-query -W -f='\${Version}\n' google-cloud-cli"
check ANSIBLE_VERSION    ansible    "pip3 show ansible | grep ^Version:"
check JINJA_VERSION      python3    "python3 -c 'import jinja2; print(jinja2.__version__)'"
check VAULT_VERSION      vault      "vault -version"

# OS check (special-cased: no command, just /etc/os-release)
if [[ -n "${PIN[UBUNTU_VERSION]:-}" ]]; then
  expected="${PIN[UBUNTU_VERSION]}"
  actual=$(. /etc/os-release && echo "$VERSION_ID")
  if [[ "$actual" == "$expected" ]]; then
    printf '✅ %-25s pin=%-15s\n' "UBUNTU_VERSION" "$expected"
    PASS=$((PASS + 1))
  else
    printf '❌ %-25s pin=%-15s — image reports %s\n' "UBUNTU_VERSION" "$expected" "$actual"
    MISMATCH=$((MISMATCH + 1))
  fi
fi

echo
echo "Summary: ✅ $PASS ok | ⚠️  $MISMATCH mismatch | ❌ $MISSING missing"

if (( MISSING > 0 || MISMATCH > 0 )); then
  exit 1
fi
