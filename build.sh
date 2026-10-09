#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DEFAULT_IMAGE_TAG="2026-10-09"
IMAGE_TAG="${IMAGE_TAG:-$DEFAULT_IMAGE_TAG}"
BUILD_ID="${BUILD_ID:-local-$(date -u +%s)}"
PRIVATE_REPOSITORY="${PRIVATE_REPOSITORY:-ksandermann/cloud-toolbox-private}"

case "${BUILD_ARCH:-$(uname -m)}" in
  amd64|x86_64) BUILD_ARCH=amd64 ;;
  arm64|aarch64) BUILD_ARCH=arm64 ;;
  *) echo "Unsupported build architecture: ${BUILD_ARCH:-$(uname -m)}" >&2; exit 1 ;;
esac
PLATFORM="linux/${BUILD_ARCH}"

declare -a buildargs_base=()
declare -a buildargs_optional=()

# mirror.openshift.com keeps only the current release under clients/ocp/stable/,
# so a pinned oc version 404s as soon as OpenShift cuts a new one. Repair the pin
# before parsing the args, otherwise the build dies on an unrelated upstream change.
bash ./ensure_oc_version.sh || echo "WARNING: oc version could not be verified, continuing with the pinned value"

# Parse args_base.args
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  buildargs_base+=(--build-arg "$line")
done < "args_base.args"

# Parse args_optional.args
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  buildargs_optional+=(--build-arg "$line")
done < "args_optional.args"

# Build complete image
build_variant() {
  local variant="$1"
  local image_tag="${PRIVATE_REPOSITORY}:ci-${BUILD_ID}-${variant}-${BUILD_ARCH}"
  local -a build_args=("${buildargs_base[@]}")

  if [[ "$variant" == "complete" ]]; then
    build_args+=("${buildargs_optional[@]}")
  fi

  echo "Building ${variant} image for ${PLATFORM} as ${image_tag}"
  docker buildx build \
    --pull \
    --provenance=false \
    "${build_args[@]}" \
    --platform "$PLATFORM" \
    --tag "$image_tag" \
    --push \
    --progress plain \
    .

  trivy image \
    --ignore-unfixed \
    --severity HIGH,CRITICAL,MEDIUM \
    --skip-files "/usr/local/bin/containerd" \
    --skip-files "/usr/local/bin/containerd-shim" \
    --skip-files "/usr/local/bin/containerd-shim-runc-v2" \
    --skip-files "/usr/local/bin/crictl" \
    --skip-files "/usr/local/bin/ctr" \
    --skip-files "/usr/local/bin/docker" \
    --skip-files "/usr/local/bin/docker-init" \
    --skip-files "/usr/local/bin/docker-proxy" \
    --skip-files "/usr/local/bin/dockerd" \
    --skip-files "/usr/local/bin/helm" \
    --skip-files "/usr/local/bin/kubectl" \
    --skip-files "/usr/local/bin/kubelogin" \
    --skip-files "/usr/local/bin/oc" \
    --skip-files "/usr/local/bin/sentinel" \
    --skip-files "/usr/local/bin/stern" \
    --skip-files "/usr/local/bin/tcpping" \
    --skip-files "/usr/local/bin/terraform" \
    --skip-files "/usr/local/bin/vault" \
    --skip-files "/usr/local/bin/velero" \
    --skip-files "/usr/local/bin/yq" \
    --skip-dirs "/root/.azure/cliextensions/ssh/" \
    "$image_tag"
}

build_variant complete
build_variant base
