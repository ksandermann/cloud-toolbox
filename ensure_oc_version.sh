#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
#  Keep OC_CLI_VERSION buildable.
#
#  mirror.openshift.com keeps only the CURRENT release under
#  clients/ocp/stable/, so a pinned oc version stops existing as soon as
#  OpenShift cuts a new one — turning a green pipeline red with a 404 that has
#  nothing to do with this repo.
#
#  This checks the pinned version first and leaves everything alone when it is
#  still downloadable. Only when it has been rotated away does it resolve the
#  current release, rewrite args_optional.args, and correct the newest README
#  table row so the documented version matches what actually gets built.
#
#  Usage:  bash ensure_oc_version.sh [--check-only]
#  Exit:   0 = pin is usable (possibly after updating), 1 = could not resolve
# ──────────────────────────────────────────────────────────────────────────
set -uo pipefail

ARGS_FILE="args_optional.args"
README_FILE="README.md"
MIRROR="https://mirror.openshift.com/pub/openshift-v4"
# The Dockerfile downloads per TARGETARCH, so a version is only usable when it
# exists for every platform we build.
ARCHES=(amd64 arm64)
CHECK_ONLY=0
[[ "${1:-}" == "--check-only" ]] && CHECK_ONLY=1

tarball_url() { echo "${MIRROR}/$1/clients/ocp/stable/openshift-client-linux-$2.tar.gz"; }

version_available() {
  local version="$1" arch code
  for arch in "${ARCHES[@]}"; do
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 30 -L "$(tarball_url "$arch" "$version")")
    [[ "$code" == "200" ]] || return 1
  done
  return 0
}

latest_stable_version() {
  # Same shape as the scrape in update_versions.sh, kept deliberately identical.
  curl -fsSL --max-time 30 "${MIRROR}/amd64/clients/ocp/stable/" \
    | grep -o 'openshift-client-linux-[0-9]*\.[0-9]*\.[0-9]*\.tar\.gz' \
    | sed 's/openshift-client-linux-\([0-9]*\.[0-9]*\.[0-9]*\)\.tar\.gz/\1/' \
    | sort -V | tail -1
}

current=$(grep -E '^OC_CLI_VERSION=' "$ARGS_FILE" | cut -d= -f2-)
if [[ -z "$current" ]]; then
  echo "ensure_oc_version: OC_CLI_VERSION not found in $ARGS_FILE" >&2
  exit 1
fi

if version_available "$current"; then
  echo "ensure_oc_version: OC_CLI_VERSION=$current is available — no change"
  exit 0
fi

echo "ensure_oc_version: OC_CLI_VERSION=$current is no longer on the mirror (rotated away)"
latest=$(latest_stable_version)
if [[ -z "$latest" ]]; then
  echo "ensure_oc_version: could not resolve the current stable release; leaving the pin untouched" >&2
  exit 1
fi
if [[ "$latest" == "$current" ]]; then
  echo "ensure_oc_version: mirror still advertises $current but it is not downloadable; leaving the pin untouched" >&2
  exit 1
fi
if ! version_available "$latest"; then
  echo "ensure_oc_version: resolved $latest but it is not downloadable on every arch; leaving the pin untouched" >&2
  exit 1
fi

if [[ "$CHECK_ONLY" == "1" ]]; then
  echo "ensure_oc_version: would update $current -> $latest (--check-only)"
  exit 0
fi

sed -i.bak -E "s/^OC_CLI_VERSION=.*/OC_CLI_VERSION=${latest}/" "$ARGS_FILE" && rm -f "${ARGS_FILE}.bak"
echo "ensure_oc_version: $ARGS_FILE  $current -> $latest"

# Correct the newest README row only. Older rows are a historical record of what
# was actually shipped, so they must not be rewritten.
if [[ -f "$README_FILE" ]]; then
  header=$(awk '/^\| RELEASE /{print NR; exit}' "$README_FILE")
  if [[ -n "$header" ]]; then
    row=$(awk -v h="$header" 'NR>h+1 && /^\| [0-9]{4}-/{print NR; exit}' "$README_FILE")
    if [[ -n "$row" ]] && sed -n "${row}p" "$README_FILE" | grep -qF "$current"; then
      # Column 15 in awk terms (leading empty field before the first pipe) is oc.
      awk -v r="$row" -v old="$current" -v new="$latest" '
        NR==r { n=split($0,f,"|"); for(i=1;i<=n;i++) if (f[i] ~ "(^| )"old"( |$)") sub(old,new,f[i]);
                out=f[1]; for(i=2;i<=n;i++) out=out "|" f[i]; print out; next }
        { print }' "$README_FILE" > "${README_FILE}.tmp" && mv "${README_FILE}.tmp" "$README_FILE"
      echo "ensure_oc_version: $README_FILE  newest row updated to $latest"
    fi
  fi
fi
exit 0
