#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


IMAGE_TAG="latest"

docker run -ti --rm \
    -v ~/.kube:/root/.kube \
    -v ~/.helm:/root/.helm \
    -v ~/.ssh:/root/.ssh \
    -v ${PWD}:/root/project \
    -v ~/.gitconfig:/root/.gitconfig \
    -v ~/.aws:/root/.aws \
    -v ~/.azure:/root/.azure \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ksandermann/cloud-toolbox:$IMAGE_TAG \
    bash
