######################################################### TOOLCHAIN VERSIONING #########################################
#settings values here to be able to use dockerhub autobuild
ARG UBUNTU_VERSION=20.04

#https://docs.docker.com/engine/release-notes/
ARG DOCKER_VERSION="20.10.18"
#https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION="1.25.1"
#https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/
ARG OC_CLI_VERSION="4.11.4"
#https://github.com/helm/helm/releases
ARG HELM_VERSION="3.9.4"
#https://github.com/hashicorp/terraform/releases
ARG TERRAFORM_VERSION="1.2.9"
#https://pypi.org/project/awscli/
ARG AWS_CLI_VERSION="1.25.77"
#https://pypi.org/project/azure-cli/
ARG AZ_CLI_VERSION="2.40.0"
#apt-get update && apt-cache madison google-cloud-sdk | head -n 1
ARG GCLOUD_VERSION="402.0.0-0"
#https://pypi.org/project/ansible/
ARG ANSIBLE_VERSION="6.4.0"
#https://pypi.org/project/Jinja2/
ARG JINJA_VERSION="3.1.2"
#https://mirror.exonetric.net/pub/OpenBSD/OpenSSH/portable/
ARG OPENSSH_VERSION="9.0p1"
#https://github.com/kubernetes-sigs/cri-tools/releases
ARG CRICTL_VERSION="1.25.0"
#https://github.com/hashicorp/vault/releases
ARG VAULT_VERSION="1.11.3"
#https://github.com/vmware-tanzu/velero/releases
ARG VELERO_VERSION="1.9.1"
#https://docs.hashicorp.com/sentinel/changelog
ARG SENTINEL_VERSION="0.18.12"
#https://github.com/stern/stern/releases
ARG STERN_VERSION="1.21.0"
#https://github.com/Azure/kubelogin/releases
ARG KUBELOGIN_VERSION="0.0.20"
#apt-get update && apt-cache madison zsh | head -n 1
ARG ZSH_VERSION="5.8-3ubuntu1.1"
ARG MULTISTAGE_BUILDER_VERSION="2022-08-25"

######################################################### BUILDER ######################################################
FROM ksandermann/multistage-builder:$MULTISTAGE_BUILDER_VERSION as builder
MAINTAINER Kevin Sandermann <kevin.sandermann@gmail.com>
LABEL maintainer="kevin.sandermann@gmail.com"

ARG TARGETARCH
ARG OC_CLI_VERSION
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG DOCKER_VERSION
ARG KUBECTL_VERSION
ARG CRICTL_VERSION
ARG VAULT_VERSION
ARG VELERO_VERSION
ARG SENTINEL_VERSION
ARG STERN_VERSION
ARG KUBELOGIN_VERSION

WORKDIR /root/download

#download oc-cli
RUN mkdir -p oc_cli && \
    curl -SsL --retry 5 -o oc_cli.tar.gz https://mirror.openshift.com/pub/openshift-v4/$TARGETARCH/clients/ocp/stable/openshift-client-linux-$OC_CLI_VERSION.tar.gz && \
    tar xvf oc_cli.tar.gz -C oc_cli

#download helm3-cli
RUN mkdir helm && curl -SsL --retry 5 "https://get.helm.sh/helm-v$HELM_VERSION-linux-$TARGETARCH.tar.gz" | tar xz -C ./helm

#download terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform\_${TERRAFORM_VERSION}\_linux_${TARGETARCH}.zip && \
    unzip ./terraform\_${TERRAFORM_VERSION}\_linux_${TARGETARCH}.zip -d terraform_cli

#download docker
#credits to https://github.com/docker-library/docker/blob/463595652d2367887b1ffe95ec30caa00179be72/18.09/Dockerfile
#need to stick to uname since docker download link uses "aarch64" instead of "arm64"
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
RUN wget https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/${TARGETARCH}/kubectl -O /root/download/kubectl

#download crictl
RUN mkdir -p /root/download/crictl && \
    wget "https://github.com/kubernetes-sigs/cri-tools/releases/download/v$CRICTL_VERSION/crictl-v$CRICTL_VERSION-linux-${TARGETARCH}.tar.gz" -O /root/download/crictl.tar.gz && \
    tar zxvf /root/download/crictl.tar.gz -C /root/download/crictl  && \
    chmod +x /root/download/crictl/crictl

#download yq
RUN curl -Lo yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${TARGETARCH}

#download vault
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    unzip ./vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip

#download tcpping
#todo: switch to https://github.com/deajan/tcpping/blob/master/tcpping when ubuntu is supported
RUN wget https://raw.githubusercontent.com/deajan/tcpping/original-1.8/tcpping -O /root/download/tcpping

#download velero CLI
RUN wget https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VERSION}/velero-v${VELERO_VERSION}-linux-${TARGETARCH}.tar.gz && \
   tar -xvf velero-v${VELERO_VERSION}-linux-${TARGETARCH}.tar.gz && \
   mkdir -p /root/download/velero_binary && \
   mv velero-v${VELERO_VERSION}-linux-${TARGETARCH}/velero /root/download/velero_binary/velero

#download terraform sentinel
RUN curl https://releases.hashicorp.com/sentinel/${SENTINEL_VERSION}/sentinel_${SENTINEL_VERSION}_linux_${TARGETARCH}.zip --output ./sentinel.zip && \
  unzip ./sentinel.zip -d ./sentinel_binary

#download stern
RUN mkdir -p /root/download/stern && \
    wget https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_${TARGETARCH}.tar.gz -O /root/download/stern_arch.tar.gz && \
    tar zxvf /root/download/stern_arch.tar.gz -C /root/download/stern && \
    mkdir -p /root/download/stern_binary && \
    mv /root/download/stern/stern /root/download/stern_binary/stern

#download kubelogin
RUN mkdir -p /root/download/kubelogin/binary && \
    wget https://github.com/Azure/kubelogin/releases/download/v${KUBELOGIN_VERSION}/kubelogin-linux-${TARGETARCH}.zip -O /root/download/kubelogin/kubelogin.zip && \
    unzip /root/download/kubelogin/kubelogin.zip -d /root/download/kubelogin/ && \
    mv /root/download/kubelogin/bin/linux_${TARGETARCH}/kubelogin /root/download/kubelogin/binary/kubelogin


######################################################### IMAGE ########################################################

FROM ubuntu:$UBUNTU_VERSION
MAINTAINER Kevin Sandermann <kevin.sandermann@gmail.com>
LABEL maintainer="kevin.sandermann@gmail.com"

ARG TARGETARCH
#tooling versions
ARG OPENSSH_VERSION
ARG KUBECTL_VERSION
ARG ANSIBLE_VERSION
ARG JINJA_VERSION
ARG AZ_CLI_VERSION
ARG AWS_CLI_VERSION
ARG ZSH_VERSION
ARG GCLOUD_VERSION

#env
ENV EDITOR nano
ENV DEBIAN_FRONTEND noninteractive

USER root
WORKDIR /root

#https://github.com/waleedka/modern-deep-learning-docker/issues/4#issue-292539892
#bc and tcptraceroute needed for tcping
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    apt-utils \
    apt-transport-https \
    bash-completion \
    bc \
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
    nmap \
    openssl \
    python3 \
    python3-dev \
    python3-pip \
    software-properties-common \
    sudo \
    telnet \
    tcptraceroute \
    traceroute \
    unzip \
    uuid-runtime \
    vim \
    wget \
    zip \
    zlib1g-dev &&\
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

#install zsh + configure git
RUN locale-gen en_US.UTF-8
RUN apt-get update && \
    apt-get install -y \
    fonts-powerline \
    powerline \
    zsh=$ZSH_VERSION
RUN git config --global --add safe.directory '*'


ENV TERM xterm
ENV ZSH_THEME agnoster
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

#install OpenSSH & remove ssh key files (this is only reasonable here since they are generated here)
RUN wget "https://mirror.exonetric.net/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz" --no-check-certificate && \
    tar xfz openssh-${OPENSSH_VERSION}.tar.gz && \
    cd openssh-${OPENSSH_VERSION} && \
    ./configure && \
    make && \
    make install && \
    rm -rf ../openssh-${OPENSSH_VERSION}.tar.gz ../openssh-${OPENSSH_VERSION} /usr/local/etc/*_key /usr/local/etc/*.pub && \
    ssh -V

#install ansible common requirements + azure-cli
RUN apt remove azure-cli -y || true && \
    pip3 install \
    ansible==${ANSIBLE_VERSION} \
    ansible-lint \
    cryptography \
    hvac \
    jinja2==${JINJA_VERSION} \
    jmespath \
    netaddr \
    openshift \
    passlib \
    pbr \
    pip \
    pyOpenSSL \
    pyvmomi \
    setuptools && \
    pip3 install \
    azure-cli==${AZ_CLI_VERSION}

#test azure-cli
RUN az --version && \
    az extension add --name azure-devops && \
    az extension add --name ssh && \
    az extension add --name serial-console && \
    az extension add --name sentinel && \
    az extension add --name resource-mover && \
    az extension add --name resource-graph && \
    az extension add --name quota && \
    az extension add --name portal && \
    az extension add --name k8sconfiguration && \
    az extension add --name k8s-extension && \
    az extension add --name k8s-configuration && \
    az extension add --name azure-firewall

#install AWS CLI
RUN pip3 install awscli==$AWS_CLI_VERSION && \
    aws --version

#install gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && \
    apt-get install -y google-cloud-sdk=${GCLOUD_VERSION}

#install binaries
COPY --from=builder "/root/download/helm/linux-${TARGETARCH}/helm" "/usr/local/bin/helm"
COPY --from=builder "/root/download/oc_cli/oc" "/usr/local/bin/oc"
COPY --from=builder "/root/download/terraform_cli/terraform" "/usr/local/bin/terraform"
COPY --from=builder "/root/download/docker/bin/*" "/usr/local/bin/"
COPY --from=builder "/root/download/kubectl" "/usr/local/bin/kubectl"
COPY --from=builder "/root/download/crictl/crictl" "/usr/local/bin/crictl"
COPY --from=builder "/root/download/yq" "/usr/local/bin/yq"
COPY --from=builder "/root/download/vault" "/usr/local/bin/vault"
COPY --from=builder "/root/download/tcpping" "/usr/local/bin/tcpping"
COPY --from=builder "/root/download/velero_binary/velero" "/usr/local/bin/velero"
COPY --from=builder "/root/download/sentinel_binary/sentinel" "/usr/local/bin/sentinel"
COPY --from=builder "/root/download/stern_binary/stern" "/usr/local/bin/stern"
COPY --from=builder "/root/download/kubelogin/binary/kubelogin" "/usr/local/bin/kubelogin"


RUN chmod -R +x /usr/local/bin && \
    helm version && \
    helm repo add stable https://charts.helm.sh/stable && \
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
    helm repo update && \
    kubectl version --client=true && \
    crictl --version && \
    oc version --client && \
    terraform version && \
    docker --version && \
    yq --version && \
    vault -version && \
    gcloud version && \
    tcpping && \
    velero --help && \
    stern --version && \
    sentinel --version && \
    kubelogin --version

COPY .bashrc /root/.bashrc
COPY .zshrc /root/.zshrc

WORKDIR /root/project
CMD ["/bin/bash"]
