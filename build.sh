#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2021-01-03_01"
UPSTREAM_TAG="latest"

docker build \
    --pull \
    --no-cache \
    -t ksandermann/cloud-toolbox:$IMAGE_TAG \
    .

#push
docker login
docker push ksandermann/cloud-toolbox:$IMAGE_TAG

docker tag ksandermann/cloud-toolbox:$IMAGE_TAG ksandermann/cloud-toolbox:$UPSTREAM_TAG
docker push ksandermann/cloud-toolbox:$UPSTREAM_TAG
