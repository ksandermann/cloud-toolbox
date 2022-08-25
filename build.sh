#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="2022-08-25_multiarch"
UPSTREAM_TAG="latest"
UPSTREAM_TAG2="project"

#https://blog.jaimyn.dev/how-to-build-multi-architecture-docker-images-on-an-m1-mac/

docker buildx build \
    --pull \
    --platform linux/amd64,linux/arm64 \
    --push \
    -t ksandermann/cloud-toolbox:$IMAGE_TAG \
    .


    #--no-cache \


#docker login
#docker push ksandermann/cloud-toolbox:$IMAGE_TAG
#
#docker tag ksandermann/cloud-toolbox:$IMAGE_TAG ksandermann/cloud-toolbox:$UPSTREAM_TAG
#docker push ksandermann/cloud-toolbox:$UPSTREAM_TAG
#
#docker tag ksandermann/cloud-toolbox:$IMAGE_TAG ksandermann/cloud-toolbox:$UPSTREAM_TAG2
#docker push ksandermann/cloud-toolbox:$UPSTREAM_TAG2
#
#
#
