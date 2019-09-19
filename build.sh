#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2019-09-19_02"

docker build \
    --pull \
    --no-cache \
    -t ksandermann/cloud-toolbox:$IMAGE_TAG \
    .

##push
docker login
docker push ksandermann/cloud-toolbox:$IMAGE_TAG

#docker tag ksandermann/cloud-toolbox:$IMAGE_TAG ksandermann/cloud-toolbox:latest
#docker push ksandermann/cloud-toolbox:latest
