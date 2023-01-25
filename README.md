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

# custom ca certificates
All CAs placed inside ```~/ca-certificates``` on the host system will be mounted into the container and trusted on startup.

# multi-platform support
Starting with release *2022-08-25_01*, arm64/aarch64 and amd64 are supported and have been tested on linux/amd64 and Macbook M1.

# versioning
Release tags will be build following pattern YYYY-MM-dd_version.

There is 3 versions of toolbox available: *base*, *complete* and *minimal*.

The latest tag of version *base* will be built using tag *latest*, while the latest tag of version *complete* is available through tag *complete*.

Version *base* of a date will always contain fixed and documented versions, aiming for the latest stable/official versions of tooling available of version *base*.

Version *complete* will be built on top of *base*, with additional tooling only available in *complete*.

For a list of tooling available in version *complete*, but not in *base*, please refer [here](https://github.com/ksandermann/cloud-toolbox/blob/master/args_optional.args).

Version *minimal* is built on top of alpine and contains a minimal set of tools, meant to be used within automation with minimal vulnerabilities.

## version history
latest=2023-01-25_base

project=2023-01-25_base

complete=2023-01-25_complete


| RELEASE             | UBUNTU | DOCKER   | KUBECTL | HELM   | TERRAFORM | AZ CLI | OPENSSH | CRICTL | VELERO | SENTINEL | STERN  | KUBELOGIN | OC CLI  | AWS CLI | GCLOUD CLI | ANSIBLE | JINJA2  | VAULT  |
|---------------------|--------|----------|---------|--------|-----------|--------|---------|--------|--------|----------|--------|-----------|---------|---------|------------|---------|---------|--------|
| 2023-01-22_complete | 20.04  | 20.10.23 | 1.26.1  | 3.11.0 | 1.3.7     | 2.44.1 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.25    | 4.12.0  | 1.27.54 | 414.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2023-01-18_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.7     | 2.44.1 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.25    | 4.12.0  | 1.27.51 | 413.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2023-01-15_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.7     | 2.44.1 | 9.1p1   | 1.26.0 | 1.9.5  | 0.19.1   | 1.22.0 | 0.0.25    | 4.11.21 | 1.27.50 | 413.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2023-01-10_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.7     | 2.44.1 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.25    | 4.11.20 | 1.27.47 | 413.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2023-01-08_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.7     | 2.43.0 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.25    | 4.11.20 | 1.27.45 | 412.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2023-01-04_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.6     | 2.43.0 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.25    | 4.11.20 | 1.27.42 | 412.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2023-01-01_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.6     | 2.43.0 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.25    | 4.11.20 | 1.27.41 | 412.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2022-12-29_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.6     | 2.43.0 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.25    | 4.11.20 | 1.27.38 | 412.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2022-12-21_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.6     | 2.43.0 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.24    | 4.11.18 | 1.27.34 | 412.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2022-12-20_complete | 20.04  | 20.10.22 | 1.26.0  | 3.10.3 | 1.3.6     | 2.43.0 | 9.1p1   | 1.26.0 | 1.10.0 | 0.19.1   | 1.22.0 | 0.0.24    | 4.11.18 | 1.27.29 | 412.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2022-12-14_complete | 20.04  | 20.10.21 | 1.26.0  | 3.10.2 | 1.3.6     | 2.43.0 | 9.1p1   | 1.25.0 | 1.10.0 | 0.19.0   | 1.22.0 | 0.0.24    | 4.11.18 | 1.27.29 | 412.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2022-12-11_complete | 20.04  | 20.10.21 | 1.26.0  | 3.10.2 | 1.3.6     | 2.43.0 | 9.1p1   | 1.25.0 | 1.10.0 | 0.19.0   | 1.22.0 | 0.0.24    | 4.11.17 | 1.27.27 | 411.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2022-12-07_complete | 20.04  | 20.10.21 | 1.25.4  | 3.10.2 | 1.3.6     | 2.43.0 | 9.1p1   | 1.25.0 | 1.10.0 | 0.19.0   | 1.22.0 | 0.0.24    | 4.11.17 | 1.27.24 | 411.0.0    | 6.7.0   | 3.1.2   | 1.12.2 |
| 2022-12-04_complete | 20.04  | 20.10.21 | 1.25.4  | 3.10.2 | 1.3.6     | 2.42.0 | 9.1p1   | 1.25.0 | 1.10.0 | 0.18.13  | 1.22.0 | 0.0.24    | 4.11.16 | 1.27.22 | 410.0.0    | 6.6.0   | 3.1.2   | 1.12.2 |
| 2022-11-30_complete | 20.04  | 20.10.21 | 1.25.4  | 3.10.2 | 1.3.5     | 2.42.0 | 9.1p1   | 1.25.0 | 1.10.0 | 0.18.13  | 1.22.0 | 0.0.24    | 4.11.13 | 1.27.19 | 410.0.0    | 6.6.0   | 3.1.2   | 1.12.1 |
| 2022-11-27_complete | 20.04  | 20.10.21 | 1.25.4  | 3.10.2 | 1.3.5     | 2.42.0 | 9.1p1   | 1.25.0 | 1.9.3  | 0.18.13  | 1.22.0 | 0.0.24    | 4.11.13 | 1.27.16 | 410.0.0    | 6.6.0   | 3.1.2   | 1.12.1 |
| 2022-11-19_complete | 20.04  | 20.10.21 | 1.25.4  | 3.10.2 | 1.3.5     | 2.42.0 | 9.1p1   | 1.25.0 | 1.9.3  | 0.18.13  | 1.22.0 | 0.0.24    | 4.11.13 | 1.27.13 | 410.0.0    | 6.6.0   | 3.1.2   | 1.12.1 |
| 2022-11-13_complete | 20.04  | 20.10.21 | 1.25.4  | 3.10.2 | 1.3.4     | 2.42.0 | 9.1p1   | 1.25.0 | 1.9.3  | 0.18.13  | 1.22.0 | 0.0.20    | 4.11.12 | 1.27.8  | 409.0.0    | 6.6.0   | 3.1.2   | 1.12.1 |
| 2022-11-05_complete | 22.04  | 20.10.20 | 1.25.3  | 3.10.1 | 1.3.4     | 2.42.0 | 9.1p1   | 1.25.0 | 1.9.2  | 0.18.11  | 1.22.0 | 0.0.20    | 4.11.9  | 1.27.3  | 408.0.1    | 6.5.0   | 3.1.2   | 1.12.1 |
| 2022-10-11_complete | 20.04  | 20.10.18 | 1.25.2  | 3.10.0 | 1.3.2     | 2.40.0 | 9.1p1   | 1.25.0 | 1.9.2  | 0.18.11  | 1.22.0 | 0.0.20    | 4.11.7  | 1.25.90 | 405.0.0    | 6.4.0   | 3.1.2   | 1.11.4 |

## [version history before 2022-10-10](https://github.com/ksandermann/cloud-toolbox/blob/master/docs/version_history.md)
