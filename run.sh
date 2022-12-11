#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

IMAGE_TAG="latest"
PULL_SETTINGS="always" #"always"|"missing"|"never"
TOOLBOX_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

#functions
function startNewToolbox {
  docker run -ti --rm \
    --name toolbox \
    -v ~/.kube:/root/.kube \
    -v ~/.helm:/root/.helm \
    -v ~/.ssh:/root/.ssh \
    -v ${PWD}:/root/project \
    -v ~/.gitconfig:/root/.gitconfig \
    -v $TOOLBOX_DIR/.autoexec.sh:/root/.autoexec.sh \
    -v ~/.aws:/root/.aws \
    -v ~/.azure:/root/.azure \
    -v ~/.config/gcloud:/root/.config/gcloud \
    -v ~/ca-certificates:/usr/local/share/ca-certificates/extra \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --env-file <(env | grep -i proxy) \
    --pull $PULL_SETTINGS \
    ksandermann/cloud-toolbox:$IMAGE_TAG \
    /bin/zsh
}

function attachToToolbox {
  docker exec -it toolbox /bin/bash
}

function testBinaries {
  docker --version && \
  yq --version && \
  tcpping && \
  helm version && \
  kubectl version --client=true && \
  crictl --version && \
  terraform version  && \
  velero version --client-only && \
  sentinel --version && \
  kubelogin --version && \
  stern --version && \
  oc version --client && \
  vault -version && \
  gcloud version
}

if [[ "$(docker ps -a | grep toolbox)" ]]
then
    attachToToolbox
else
    startNewToolbox
fi
