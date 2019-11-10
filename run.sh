#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

TOOLBOX_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

IMAGE_TAG="zsh"

docker run -ti --rm \
    -v ~/.kube:/root/.kube \
    -v ~/.helm:/root/.helm \
    -v ~/.ssh:/root/.ssh \
    -v ${PWD}:/root/project \
    -v ~/.gitconfig:/root/.gitconfig \
    -v $TOOLBOX_DIR/.autoexec.sh:/root/.autoexec.sh \
    -v ~/.aws:/root/.aws \
    -v ~/.azure:/root/.azure \
    -v /usr/local/share/ca-certificates/extra:/usr/local/share/ca-certificates/extra \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --env-file <(env | grep proxy) \
    ksandermann/cloud-toolbox:$IMAGE_TAG \
    /bin/zsh
