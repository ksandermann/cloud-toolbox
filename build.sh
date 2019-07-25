#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="local"

docker build \
    --pull \
    --no-cache \
    -t ksandermann/cloud-toolbox:$IMAGE_TAG \
    \

##push
#docker login
#docker push $IMAGE_TAG