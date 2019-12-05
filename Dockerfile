######################################################### TOOLCHAIN VERSIONING #########################################
#settings values here to be able to use dockerhub autobuild
ARG UBUNTU_VERSION=18.04

ARG OC_CLI_SOURCE="https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz"

ARG HELM_VERSION="3.0.1"
ARG TERRAFORM_VERSION="0.12.17"
ARG OPENSSH_VERSION="8.1p1"
ARG KUBECTL_VERSION="1.16.3"
ARG ANSIBLE_VERSION="2.9.2"
ARG JINJA_VERSION="2.10.3"
ARG AZ_CLI_VERSION="2.0.77-1~bionic"
ARG AWS_CLI_VERSION="1.16.297"
ARG DOCKER_VERSION="19.03.5"
ARG KOPS_VERSION="1.15.0"
ARG ZSH_VERSION="5.4.2-3ubuntu3.1"

ARG TILLER_NAMESPACE=kubetools


######################################################### BUILDER ######################################################
FROM ksandermann/multistage-builder:2019-09-17 as builder
MAINTAINER Kevin Sandermann <kevin.sandermann@gmail.com>
LABEL maintainer="kevin.sandermann@gmail.com"

ARG OC_CLI_SOURCE
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG DOCKER_VERSION
ARG KUBECTL_VERSION
ARG KOPS_VERSION


#download oc-cli
WORKDIR /root/download
RUN touch oc_cli.tar.gz && \
    mkdir -p oc_cli && \
    curl -SsL --retry 5 -o oc_cli.tar.gz $OC_CLI_SOURCE && \
    tar xf oc_cli.tar.gz -C oc_cli && \
    cp oc_cli/*/* oc_cli

#download helm-cli
RUN curl -SsL --retry 5 "https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz" | tar xz

#download terraform
WORKDIR /root/download
RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform\_$TERRAFORM_VERSION\_linux_amd64.zip && \
    unzip ./terraform\_$TERRAFORM_VERSION\_linux_amd64.zip -d terraform_cli

#download docker
#credits to https://github.com/docker-library/docker/blob/463595652d2367887b1ffe95ec30caa00179be72/18.09/Dockerfile
RUN mkdir -p /root/download/docker/bin && \
    set -eux; \
    arch="$(uname -m)"; \
    if ! wget -O docker.tgz "https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz"; then \
        echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from 'stable' for '${arch}'"; \
        exit 1; \
    fi; \
    tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /root/download/docker/bin

#download kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl -O /root/download/kubectl

#download kops
RUN curl -Lo kops https://github.com/kubernetes/kops/releases/download/$KOPS_VERSION/kops-linux-amd64

######################################################### IMAGE ########################################################

FROM ubuntu:18.04
MAINTAINER Kevin Sandermann <kevin.sandermann@gmail.com>
LABEL maintainer="kevin.sandermann@gmail.com"

# tooling versions
ARG OPENSSH_VERSION
ARG KUBECTL_VERSION
ARG ANSIBLE_VERSION
ARG JINJA_VERSION
ARG AZ_CLI_VERSION
ARG AWS_CLI_VERSION
ARG ZSH_VERSION


ARG TILLER_NAMESPACE

#env
ENV TILLER_NAMESPACE $TILLER_NAMESPACE

USER root
WORKDIR /root

#https://github.com/waleedka/modern-deep-learning-docker/issues/4#issue-292539892
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    apt-utils \
    apt-transport-https \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    dnsutils \
    fping \
    git \
    gnupg \
    gnupg2 \
    groff \
    iputils-ping \
    jq \
    less \
    libssl-dev \
    locales \
    lsb-release \
    nano \
    net-tools \
    netcat \
    python3 \
    python3-dev \
    python3-pip \
    software-properties-common \
    sudo \
    telnet \
    unzip \
    uuid-runtime \
    vim \
    wget \
    zlib1g-dev &&\
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

#install zsh
RUN locale-gen en_US.UTF-8
RUN apt-get update && \
    apt-get install -y \
    fonts-powerline \
    powerline \
    zsh=$ZSH_VERSION

ENV TERM xterm
ENV ZSH_THEME agnoster
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

#keep standard shell for automation usecases
#RUN chsh -s /bin/zsh

#install OpenSSH
RUN wget "http://mirror.exonetric.net/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz" && \
    tar xfz openssh-${OPENSSH_VERSION}.tar.gz && \
    cd openssh-${OPENSSH_VERSION} && \
    ./configure && \
    make && \
    make install && \
    ssh -V

#install ansible + common requirements
RUN pip3 install pip --upgrade
RUN pip3 install cryptography==2.3
RUN pip3 install \
    ansible==${ANSIBLE_VERSION} \
    ansible-lint \
    hvac \
    jinja2==${JINJA_VERSION} \
    jmespath \
    netaddr \
    openshift \
    passlib \
    pbr==5.1.1 \
    pip \
    pyOpenSSL \
    pyvmomi

#install AWS CLI
RUN pip3 install awscli==$AWS_CLI_VERSION --upgrade && \
    aws --version


#install azure cli
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli=$AZ_CLI_VERSION && \
    az --version && \
    az extension add --name azure-devops

#install helm, oc-cli, terraform, docker and kops
COPY --from=builder "/root/download/linux-amd64/helm" "/usr/local/bin/helm"
COPY --from=builder "/root/download/oc_cli/oc" "/usr/local/bin/oc"
COPY --from=builder "/root/download/terraform_cli/terraform" "/usr/local/bin/terraform"
COPY --from=builder "/root/download/docker/bin/*" "/usr/local/bin/"
COPY --from=builder "/root/download/kubectl" "/usr/local/bin/kubectl"
COPY --from=builder "/root/download/kops" "/usr/local/bin/kops"

RUN chmod +x \
    "/usr/local/bin/helm" \
    "/usr/local/bin/oc" \
    "/usr/local/bin/terraform" \
    "/usr/local/bin/kubectl" \
    "/usr/local/bin/containerd" \
    "/usr/local/bin/containerd-shim" \
    "/usr/local/bin/docker" \
    "/usr/local/bin/docker-init" \
    "/usr/local/bin/docker-proxy" \
    "/usr/local/bin/dockerd" \
    "/usr/local/bin/kops" && \
    helm version --client && \
    kubectl version --client=true && \
    terraform version && \
    docker --version && \
    kops version

COPY .bashrc /root/.bashrc
COPY .zshrc /root/.zshrc

WORKDIR /root/project
CMD ["/bin/zsh"]
