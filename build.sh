#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2021-04-17_01"
UPSTREAM_TAG="latest"
UPSTREAM_TAG2="project"

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

docker tag ksandermann/cloud-toolbox:$IMAGE_TAG ksandermann/cloud-toolbox:$UPSTREAM_TAG2
docker push ksandermann/cloud-toolbox:$UPSTREAM_TAG2
