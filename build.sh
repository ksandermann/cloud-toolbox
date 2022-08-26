#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2022-08-25"
UPSTREAM_TAG="latest"
UPSTREAM_TAG2="project"

docker login

#https://blog.jaimyn.dev/how-to-build-multi-architecture-docker-images-on-an-m1-mac/
docker buildx build \
    --no-cache \
    --pull \
    --platform linux/amd64,linux/arm64 \
    --push \
    -t ksandermann/cloud-toolbox:$IMAGE_TAG \
    -t ksandermann/cloud-toolbox:$UPSTREAM_TAG \
    -t ksandermann/cloud-toolbox:$UPSTREAM_TAG2 \
    .
