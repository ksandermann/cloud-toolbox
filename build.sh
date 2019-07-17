#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="ksandermann/cloud-toolbox:local"

docker build --pull --no-cache -t $IMAGE_TAG .

##push
#docker login
#docker push $IMAGE_TAG