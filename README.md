<p align="center">
 <img width="100px" src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Circle-icons-tools.svg/512px-Circle-icons-tools.svg.png" align="center" alt="Cloud Toolbox" />
 <h2 align="center">Cloud-Toolbox</h2>
 <p align="center">Docker Image to work with Azure, AWS, Google Cloud, Docker, Kubernetes, Openshift, Helm, Ansible, Terraform and HashiCorp Vault.</p>
 <p align="center">It's the toolchain I'm working with on a daily basis, packed into a docker image with both zsh and bash to have a
platform-independent development environment.</p>
 <p align="center">Feel free to use/share/contribute.</p>
</p>
<p align="center">
    <a href="https://github.com/ksandermann/cloud-toolbox/releases">
      <img alt="GitHub Releases" src="https://img.shields.io/github/v/release/ksandermann/cloud-toolbox?color=B689B2" />
    </a>
    <a href="https://hub.docker.com/repository/docker/ksandermann/cloud-toolbox">
      <img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/ksandermann/cloud-toolbox?color=D9A0B9" />
    </a>
    <a href="https://github.com/ksandermann/cloud-toolbox/pulls?q=is%3Apr+is%3Aclosed">
      <img alt="Closed pull requests" src="https://img.shields.io/github/issues-pr-closed-raw/ksandermann/cloud-toolbox?color=F2B8B9" />
    </a>
    <a href="https://github.com/ksandermann/cloud-toolbox/pulls">
      <img alt="Open pull requests" src="https://img.shields.io/github/issues-pr-raw/ksandermann/cloud-toolbox?color=FBE3B0" />
    </a>
    <a href="https://github.com/ksandermann/cloud-toolbox/issues">
      <img alt="Issues" src="https://img.shields.io/github/issues/ksandermann/cloud-toolbox?color=FCF8D9" />
    </a>
    <a href="https://github.com/ksandermann/cloud-toolbox/graphs/contributors">
      <img alt="GitHub Contributors" src="https://img.shields.io/github/contributors/ksandermann/cloud-toolbox?color=B6D8DB" />
    </a>
    <br />
    <br />
</p>

# default shell & custom startup-script
The default shell is sh.
However, the CMD step inside the Dockerfile points to /bin/bash.
By default, the file .autoexec.sh will be mounted into the container and sourced inside both bash and zsh.

# run.sh
The behaviour of run.sh is as follows:
1. check if there is already a running toolbox.
1. if so, attach to the container and start a new shell (/bin/bash) inside it.
1. if not, pull latest tag and start a new interactive container and start a new shell (/bin/zsh) inside it.

# custom ca certificates`
All CAs placed inside ```~/ca-certificates``` on the host system will be mounted into the container and trusted on startup.

# multi-platform support
Starting with release *2022-08-25_01*, arm64/aarch64 and amd64 are supported and have been tested on linux/amd64 and Macbook M1.

# versioning
Release tags will be build following pattern YYYY-MM-dd_version.
There is 2 versions of toolbox available: *base* and *complete*.
The latest tag of version *base* will be built using tag *latest*, while the latest tag of version *complete* is available through tag *complete*.
Version *base* of a date will always contain the latest stable/official versions of tooling available of version *base*.
Version *complete* will always contain the latest stable/official versions of tooling available of version *complete*.
For a list of tooling available in version *complete*, but not in *base*, please refer [here](https://github.com/ksandermann/cloud-toolbox/blob/master/docs/args_optional.args)

## version history
latest -> 2022-10-06_base
complete -> 2022-10-06_complete

| RELEASE             | UBUNTU | DOCKER   | KUBECTL | HELM   | TERRAFORM | AZ CLI | OPENSSH | CRICTL | VELERO | SENTINEL | STERN  | KUBELOGIN | OC CLI | AWS CLI | GCLOUD SDK  | ANSIBLE | JINJA2  | VAULT  |
|---------------------|--------|----------|---------|--------|-----------|--------|---------|--------|--------|----------|--------|-----------|--------|---------|-------------|---------|---------|--------|
| 2022-10-11_complete | 20.04  | 20.10.18 | 1.25.2  | 3.10.0 | 1.3.1     | 2.40.0 | 9.1p1   | 1.25.0 | 1.9.2  | 0.18.12  | 1.22.0 | 0.0.20    | 4.11.7 | 1.25.88 | 402.0.0     | 6.4.0   | 3.1.2   | 1.11.4 |

## version history
## [version history before 2022-10-05](https://github.com/ksandermann/cloud-toolbox/blob/master/docs/version_history.md)


TODO
uncomment sleep
remove test tags
add binary checks
remove plain output
update to current date
change branch & PR
add project tag in script
