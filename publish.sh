#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

: "${BUILD_ID:?BUILD_ID must identify this workflow run}"
: "${IMAGE_TAG:?IMAGE_TAG must be the release date}"
: "${PUBLISH_MODE:?PUBLISH_MODE must be release or test}"

PUBLIC_REPOSITORY="${PUBLIC_REPOSITORY:-ksandermann/cloud-toolbox}"
PRIVATE_REPOSITORY="${PRIVATE_REPOSITORY:-ksandermann/cloud-toolbox-private}"

publish_manifest() {
  local variant="$1"
  shift
  local source_amd64="${PRIVATE_REPOSITORY}:ci-${BUILD_ID}-${variant}-amd64"
  local source_arm64="${PRIVATE_REPOSITORY}:ci-${BUILD_ID}-${variant}-arm64"
  local tag
  local -a output_tags=()

  for tag in "$@"; do
    output_tags+=(--tag "${PUBLIC_REPOSITORY}:${tag}")
  done

  echo "Publishing ${variant} manifest from ${source_amd64} and ${source_arm64}"
  docker buildx imagetools create \
    "${output_tags[@]}" \
    "$source_amd64" \
    "$source_arm64"

  for tag in "$@"; do
    echo "Verifying ${PUBLIC_REPOSITORY}:${tag}"
    docker buildx imagetools inspect --raw "${PUBLIC_REPOSITORY}:${tag}" \
      | jq -e '([.manifests[]? | select(.platform.os == "linux" and (.platform.architecture == "amd64" or .platform.architecture == "arm64")) | .platform.architecture] | unique) == ["amd64", "arm64"]' \
      > /dev/null
  done
}

case "$PUBLISH_MODE" in
  test)
    publish_manifest base "test-${BUILD_ID}-latest"
    publish_manifest complete "test-${BUILD_ID}-complete"
    ;;
  release)
    publish_manifest base "${IMAGE_TAG}_latest" latest project
    publish_manifest complete "${IMAGE_TAG}_complete" complete
    ;;
  *)
    echo "Unsupported PUBLISH_MODE: ${PUBLISH_MODE}" >&2
    exit 1
    ;;
esac