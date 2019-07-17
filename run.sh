#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


IMAGE_TAG="ksandermann/cloud-toolbox:latest"

docker run -ti --rm \
    -v ~/.kube:/root/.kube \
    -v ~/.ssh:/root/.ssh \
    -v ${PWD}:/root/project \
    -v ~/.gitconfig:/root/.gitconfig \
    -v ~/.aws:/root/.aws \
    -v ~/.azure:/root/.azure \
    $IMAGE_TAG \
    bash
