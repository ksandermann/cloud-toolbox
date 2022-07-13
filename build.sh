#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2022-07-13_01"
UPSTREAM_TAG="latest"
UPSTREAM_TAG2="project"

docker build \
    --pull \
    --no-cache \
    -t ksandermann/cloud-toolbox:$IMAGE_TAG \
    .


docker login
docker push ksandermann/cloud-toolbox:$IMAGE_TAG

docker tag ksandermann/cloud-toolbox:$IMAGE_TAG ksandermann/cloud-toolbox:$UPSTREAM_TAG
docker push ksandermann/cloud-toolbox:$UPSTREAM_TAG

docker tag ksandermann/cloud-toolbox:$IMAGE_TAG ksandermann/cloud-toolbox:$UPSTREAM_TAG2
docker push ksandermann/cloud-toolbox:$UPSTREAM_TAG2
