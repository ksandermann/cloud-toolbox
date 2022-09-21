#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2022-09-21_01"
UPSTREAM_TAG="latest"

docker login

#https://blog.jaimyn.dev/how-to-build-multi-architecture-docker-images-on-an-m1-mac/
docker buildx build \
    --pull \
    --platform linux/amd64,linux/arm64 \
    -t ksandermann/cloud-toolbox-private:$IMAGE_TAG \
    .
#
#docker pull ksandermann/cloud-toolbox-private:$IMAGE_TAG
#
#trivy image \
#    --ignore-unfixed \
#    --severity HIGH,CRITICAL,MEDIUM \
#    ksandermann/cloud-toolbox-private:$IMAGE_TAG
#
#docker-squash \
#    ksandermann/cloud-toolbox-private:$IMAGE_TAG
#
#docker manifest create ksandermann/cloud-toolbox:$UPSTREAM_TAG \
#    --amend ksandermann/cloud-toolbox-private:$IMAGE_TAG
#
#docker manifest push ksandermann/cloud-toolbox:$IMAGE_TAG
#
#docker manifest create ksandermann/cloud-toolbox:$UPSTREAM_TAG \
#    --amend ksandermann/cloud-toolbox:$IMAGE_TAG
#
#docker manifest push ksandermann/cloud-toolbox:$UPSTREAM_TAG
