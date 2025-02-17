######################################################### TOOLCHAIN VERSIONING #########################################
ARG MULTISTAGE_BUILDER_VERSION
ARG UBUNTU_VERSION
ARG DOCKER_VERSION
ARG KUBECTL_VERSION
ARG OC_CLI_VERSION
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG AWS_CLI_VERSION
ARG AZ_CLI_VERSION
ARG GCLOUD_VERSION
ARG ANSIBLE_VERSION
ARG JINJA_VERSION
ARG OPENSSH_VERSION
ARG CRICTL_VERSION
ARG VAULT_VERSION
ARG VELERO_VERSION
ARG SENTINEL_VERSION
ARG STERN_VERSION
ARG KUBELOGIN_VERSION
ARG ZSH_VERSION

######################################################### BINARY-DOWNLOADER ############################################
FROM ksandermann/multistage-builder:$MULTISTAGE_BUILDER_VERSION as binary_downloader
MAINTAINER Kevin Sandermann <kevin.sandermann@gmail.com>
LABEL maintainer="kevin.sandermann@gmail.com"

ARG TARGETARCH
ARG DOCKER_VERSION
ARG KUBECTL_VERSION
ARG OC_CLI_VERSION
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG AWS_CLI_VERSION
ARG AZ_CLI_VERSION
ARG GCLOUD_VERSION
ARG ANSIBLE_VERSION
ARG JINJA_VERSION
ARG OPENSSH_VERSION
ARG CRICTL_VERSION
ARG VAULT_VERSION
ARG VELERO_VERSION
ARG SENTINEL_VERSION
ARG STERN_VERSION
ARG KUBELOGIN_VERSION
ARG ZSH_VERSION

WORKDIR /root/download

RUN mkdir -p /root/download/binaries

#download oc-cli
RUN if [[ ! -z ${OC_CLI_VERSION} ]] ; then \
      mkdir -p oc_cli && \
      curl -SsL --retry 5 -o oc_cli.tar.gz https://mirror.openshift.com/pub/openshift-v4/$TARGETARCH/clients/ocp/stable/openshift-client-linux-$OC_CLI_VERSION.tar.gz && \
      tar xvf oc_cli.tar.gz -C oc_cli && \
      mv "/root/download/oc_cli/oc" "/root/download/binaries/oc"; \
    fi

#download helm3-cli
RUN if [[ ! -z ${HELM_VERSION} ]] ; then \
      mkdir helm && curl -SsL --retry 5 "https://get.helm.sh/helm-v$HELM_VERSION-linux-$TARGETARCH.tar.gz" | tar xz -C ./helm && \
      mv "/root/download/helm/linux-${TARGETARCH}/helm" "/root/download/binaries/helm"; \
    fi

#download terraform
RUN if [[ ! -z ${TERRAFORM_VERSION} ]] ; then \
      wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform\_${TERRAFORM_VERSION}\_linux_${TARGETARCH}.zip && \
      unzip ./terraform\_${TERRAFORM_VERSION}\_linux_${TARGETARCH}.zip -d terraform_cli && \
      mv "/root/download/terraform_cli/terraform" "/root/download/binaries/terraform"; \
    fi

#download docker
#credits to https://github.com/docker-library/docker/blob/463595652d2367887b1ffe95ec30caa00179be72/18.09/Dockerfile
#need to stick to uname since docker download link uses "aarch64" instead of "arm64"
RUN if [[ ! -z ${DOCKER_VERSION} ]] ; then \
      mkdir -p /root/download/docker/bin && \
      set -eux && \
      arch="$(uname -m)" && \
      wget -q -O docker.tgz "https://download.docker.com/linux/static/stable/${arch}/docker-${DOCKER_VERSION}.tgz" && \
      tar --extract \
          --file docker.tgz \
          --strip-components 1 \
          --directory /root/download/docker/bin && \
      mv /root/download/docker/bin/* -t "/root/download/binaries/" ; \
    fi

RUN if [[ ! -z ${KUBECTL_VERSION} ]] ; then \
      wget -q https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/${TARGETARCH}/kubectl -O /root/download/kubectl && \
      chmod +x /root/download/kubectl && \
      mv "/root/download/kubectl" "/root/download/binaries/kubectl"; \
    fi

#download crictl
RUN if [[ ! -z ${CRICTL_VERSION} ]] ; then \
      mkdir -p /root/download/crictl && \
      wget -q "https://github.com/kubernetes-sigs/cri-tools/releases/download/v$CRICTL_VERSION/crictl-v$CRICTL_VERSION-linux-${TARGETARCH}.tar.gz" -O /root/download/crictl.tar.gz && \
      tar zxvf /root/download/crictl.tar.gz -C /root/download/crictl && \
      mv "/root/download/crictl/crictl" "/root/download/binaries/crictl"; \
    fi

#download yq
RUN curl -Lo yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${TARGETARCH} && \
    mv "/root/download/yq" "/root/download/binaries/yq"

#download vault
RUN if [[ ! -z ${VAULT_VERSION} ]] ; then \
      wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
      unzip ./vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
      mv "/root/download/vault" "/root/download/binaries/vault"; \
    fi

#download tcpping
#todo: switch to https://github.com/deajan/tcpping/blob/master/tcpping when ubuntu is supported
RUN wget -q https://raw.githubusercontent.com/deajan/tcpping/original-1.8/tcpping -O /root/download/tcpping && \
    mv "/root/download/tcpping" "/root/download/binaries/tcpping"

#download velero CLI
RUN if [[ ! -z ${VELERO_VERSION} ]] ; then \
      wget -q https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VERSION}/velero-v${VELERO_VERSION}-linux-${TARGETARCH}.tar.gz && \
      tar -xvf velero-v${VELERO_VERSION}-linux-${TARGETARCH}.tar.gz && \
      mv velero-v${VELERO_VERSION}-linux-${TARGETARCH}/velero /root/download/binaries/velero; \
    fi

#download terraform sentinel
RUN if [[ ! -z ${SENTINEL_VERSION} ]] ; then \
      curl https://releases.hashicorp.com/sentinel/${SENTINEL_VERSION}/sentinel_${SENTINEL_VERSION}_linux_${TARGETARCH}.zip --output ./sentinel.zip && \
      unzip ./sentinel.zip -d ./sentinel_binary && \
      mv "/root/download/sentinel_binary/sentinel" "/root/download/binaries/sentinel"; \
    fi

#download stern
RUN if [[ ! -z ${STERN_VERSION} ]] ; then \
      mkdir -p /root/download/stern && \
      wget -q https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_${TARGETARCH}.tar.gz -O /root/download/stern_arch.tar.gz && \
      tar zxvf /root/download/stern_arch.tar.gz -C /root/download/stern && \
      mv /root/download/stern/stern "/root/download/binaries/stern" ; \
    fi

#download kubelogin
RUN if [[ ! -z ${KUBELOGIN_VERSION} ]] ; then \
      mkdir -p /root/download/kubelogin/binary && \
      wget -q https://github.com/Azure/kubelogin/releases/download/v${KUBELOGIN_VERSION}/kubelogin-linux-${TARGETARCH}.zip -O /root/download/kubelogin/kubelogin.zip && \
      unzip /root/download/kubelogin/kubelogin.zip -d /root/download/kubelogin/ && \
      mv /root/download/kubelogin/bin/linux_${TARGETARCH}/kubelogin "/root/download/binaries/kubelogin" ; \
    fi

######################################################### BASE-IMAGE ###################################################

FROM ubuntu:$UBUNTU_VERSION as base-image

ARG TARGETARCH
ARG DOCKER_VERSION
ARG KUBECTL_VERSION
ARG OC_CLI_VERSION
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG AWS_CLI_VERSION
ARG AZ_CLI_VERSION
ARG GCLOUD_VERSION
ARG ANSIBLE_VERSION
ARG JINJA_VERSION
ARG OPENSSH_VERSION
ARG CRICTL_VERSION
ARG VAULT_VERSION
ARG VELERO_VERSION
ARG SENTINEL_VERSION
ARG STERN_VERSION
ARG KUBELOGIN_VERSION
ARG ZSH_VERSION

#use bash during docker build
SHELL ["/bin/bash", "-c"]

#env
ENV DEBIAN_FRONTEND noninteractive

USER root
WORKDIR /root

#Issue 17.02.2025
#https://github.com/waleedka/modern-deep-learning-docker/issues/4#issue-292539892
#bc and tcptraceroute needed for tcping
RUN apt-get update && apt-get install -y --no-install-recommends libc-bin

RUN apt-get install -y \
    apt-utils \
    apt-transport-https \
    bash-completion \
    bc \
    build-essential \
    ca-certificates

RUN apt-get install -y \
    curl \
    dnsutils \
    fping \
    git \
    gnupg \
    gnupg2 \
    groff \
    iputils-ping

RUN apt-get install -y \
    jq \
    less \
    libssl-dev \
    locales \
    lsb-release \
    nano \
    net-tools \
    netcat \
    nmap \
    openssl

RUN apt-get install -y \
    python3 \
    python3-dev \
    python3-pip \
    software-properties-common \
    sudo \
    telnet

RUN apt-get install -y \
    tcptraceroute \
    traceroute \
    unzip \
    uuid-runtime \
    vim \
    wget \
    zip \
    zlib1g-dev

RUN apt-get clean -y && \
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
    zsh=${ZSH_VERSION}
RUN git config --global --add safe.directory '*'

RUN apt-mark unhold libc-bin

#install OpenSSH & remove ssh key files (this is only reasonable here since they are generated here)
RUN if [[ ! -z ${OPENSSH_VERSION} ]] ; then \
      wget -q "https://mirror.exonetric.net/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz" --no-check-certificate && \
      tar xfz openssh-${OPENSSH_VERSION}.tar.gz && \
      cd openssh-${OPENSSH_VERSION} && \
      apt-get update && apt-get install openssl -y && \
      ./configure && \
      make && \
      make install && \
      rm -rf ../openssh-${OPENSSH_VERSION}.tar.gz ../openssh-${OPENSSH_VERSION} /usr/local/etc/*_key /usr/local/etc/*.pub && \
      ssh -V; \
    fi

# upgrade pip 
RUN pip3 install --upgrade pip 

#install common requirements
RUN pip3 install \
    cryptography \
    hvac \
    jmespath \
    netaddr \
    passlib \
    pbr \
    pip \
    pyOpenSSL \
    pyvmomi \
    setuptools

#install ansible
RUN if [[ ! -z ${ANSIBLE_VERSION} && ! -z ${JINJA_VERSION} ]] ; then \
      pip3 install \
      ansible==${ANSIBLE_VERSION} \
      ansible-lint \
      jinja2==${JINJA_VERSION}; \
    fi

#install azure-cli
RUN if [[ ! -z ${AZ_CLI_VERSION} ]] ; then \
      pip3 install --no-cache-dir --ignore-installed azure-cli==${AZ_CLI_VERSION}; \
    fi

#test azure-cli
RUN if [[ ! -z ${AZ_CLI_VERSION} ]] ; then \
      az --version && \
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
      az extension add --name azure-firewall; \
    fi

#install AWS CLI
RUN if [[ ! -z ${AWS_CLI_VERSION} ]] ; then \
      pip3 install awscli==$AWS_CLI_VERSION && \
      aws --version; \
    fi

#install gcloud
RUN if [[ ! -z ${GCLOUD_VERSION} ]] ; then \
      echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
      apt-get update && apt-get install -y google-cloud-cli; \
    fi

ENV TERM xterm
ENV ZSH_THEME agnoster
RUN wget -q https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

######################################################### IMAGE ########################################################
FROM base-image
MAINTAINER Kevin Sandermann <kevin.sandermann@gmail.com>
LABEL maintainer="kevin.sandermann@gmail.com"

ARG TARGETARCH
ARG DOCKER_VERSION
ARG KUBECTL_VERSION
ARG OC_CLI_VERSION
ARG HELM_VERSION
ARG TERRAFORM_VERSION
ARG AWS_CLI_VERSION
ARG AZ_CLI_VERSION
ARG GCLOUD_VERSION
ARG ANSIBLE_VERSION
ARG JINJA_VERSION
ARG OPENSSH_VERSION
ARG CRICTL_VERSION
ARG VAULT_VERSION
ARG VELERO_VERSION
ARG SENTINEL_VERSION
ARG STERN_VERSION
ARG KUBELOGIN_VERSION
ARG ZSH_VERSION

#use bash during docker build
SHELL ["/bin/bash", "-c"]

#env
ENV EDITOR nano

#copy binaries
COPY --from=binary_downloader "/root/download/binaries/*" "/usr/local/bin/"

RUN chmod -R +x /usr/local/bin && \
    docker --version && \
    yq --version && \
    tcpping; \
    if [[ ! -z "HELM_VERSION" ]] ; then \
      helm version && \
      helm repo add stable https://charts.helm.sh/stable && \
      helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
      helm repo update; \
    fi; \
    if [[ ! -z "KUBECTL_VERSION" ]] ; then \
      kubectl version --client=true; \
    fi; \
    if [[ ! -z "CRICTL_VERSION" ]] ; then \
      crictl --version; \
    fi; \
    if [[ ! -z "OC_CLI_VERSION" ]] ; then \
      oc version --client; \
    fi; \
    if [[ ! -z "TERRAFORM_VERSION" ]] ; then \
      terraform version ; \
    fi; \
    if [[ ! -z "VAULT_VERSION" ]] ; then \
      vault -version; \
    fi; \
    if [[ ! -z "GCLOUD_VERSION" ]] ; then \
      gcloud version; \
    fi; \
    if [[ ! -z "VELERO_VERSION" ]] ; then \
      velero version --client-only; \
    fi; \
    if [[ ! -z "STERN_VERSION" ]] ; then \
      stern --version; \
    fi; \
    if [[ ! -z "SENTINEL_VERSION" ]] ; then \
      sentinel --version; \
    fi; \
    if [[ ! -z "KUBELOGIN_VERSION" ]] ; then \
      kubelogin --version ; \
    fi

COPY .bashrc /root/.bashrc
COPY .zshrc /root/.zshrc

USER root
WORKDIR /root/project
CMD ["/bin/bash"]
