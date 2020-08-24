# cloud-toolbox
Docker Image to work with Azure, AWS, Google Cloud, Docker, Kubernetes, Openshift, Helm, Ansible, kops and Terraform.
It's the toolchain I'm working with on a daily basis, packed into a docker image with both zsh and bash to have a 
platform-independent development environment.
Feel free to use/share/contribute.

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

# helm 3 and terraform 0.13
While a lot of projects are upgrading to helm 3, helm 2 will probably still be around for some time.
As helm 3 does not provide backward-compatibility, both versions are installed in parallel in cloud-toolbox.
Helm 2 can be used as before to provide backward-compatibility, helm 3 can be used via binary `helm3`.
The same pattern applies to terraform 0.12 and 0.13 - 0.12 can be used via binary `terraform`, while 0.13 is available via binary `terraform13`.

# versioning 
Release tags will be build following pattern YYYY-MM-dd-version.
Version 01 of a date will always contain the latest stable/official versions of tooling available.
Other versions of a date can contain version combinations of the toolchain and will be documented in the version history
below.

## version history
latest -> 2020-24-08_01

project -> 2020-24-08_02


| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI | HELM    | HELM3   | TERRAFORM | TERRAFORM13   | AWS CLI  | AZ CLI | GCLOUD SDK | KOPS   | ANSIBLE | JINJA2 | OPENSSH |
|---------------|--------|----------|----------|--------|---------|---------|-----------|---------------|----------|--------|------------|--------|---------|--------|---------|
| 2020-08-24_01 | 18.04  | 19.03.12 | 1.18.8   | 4.6    | 2.16.10 | 3.3.0   | 0.12.29   | 0.13.0        | 1.18.124 | 2.10.1 | 306.0.0    | 1.18.0 | 2.9.12  | 2.11.2 | 8.3p1   |
| 2020-08-24_02 | 18.04  | 19.03.12 | 1.16.14  | 4.6    | 2.16.1  | 3.3.0   | 0.12.29   | 0.13.0        | 1.18.124 | 2.10.1 | 306.0.0    | 1.18.0 | 2.9.12  | 2.11.2 | 8.3p1   |
| 2020-08-13_01 | 18.04  | 19.03.12 | 1.18.6   | 3.11   | 2.16.10 | 3.3.0   | 0.12.29   | 0.13.0        | 1.18.118 | 2.10.1 | 305.0.0    | 1.18.0 | 2.9.12  | 2.11.2 | 8.3p1   |
| 2020-08-13_02 | 18.04  | 19.03.12 | 1.16.13  | 3.11   | 2.16.1  | 3.3.0   | 0.12.29   | 0.13.0        | 1.18.118 | 2.10.1 | 305.0.0    | 1.18.0 | 2.9.12  | 2.11.2 | 8.3p1   |
| 2020-08-07_01 | 18.04  | 19.03.12 | 1.18.6   | 3.11   | 2.16.9  | 3.2.4   | 0.12.29   | 0.13.0-rc1    | 1.18.114 | 2.10.1 | 304.0.0    | 1.18.0 | 2.9.11  | 2.11.2 | 8.3p1   |
| 2020-08-07_02 | 18.04  | 19.03.12 | 1.16.13  | 3.11   | 2.16.1  | 3.2.4   | 0.12.29   | 0.13.0-rc1    | 1.18.114 | 2.10.1 | 304.0.0    | 1.18.0 | 2.9.11  | 2.11.2 | 8.3p1   |
| 2020-07-12_01 | 18.04  | 19.03.11 | 1.18.5   | 3.11   | 2.16.9  | 3.2.4   | 0.12.28   | 0.13.0-beta3  | 1.18.97  | 2.8.0  | 300.0.0    | 1.17.1 | 2.9.10  | 2.11.2 | 8.3p1   |
| 2020-07-12_02 | 18.04  | 19.03.11 | 1.16.12  | 3.11   | 2.16.1  | 3.2.4   | 0.12.28   | 0.13.0-beta3  | 1.18.97  | 2.8.0  | 300.0.0    | 1.17.1 | 2.9.10  | 2.11.2 | 8.3p1   |


## [ version history before 2020-07-12](https://github.com/ksandermann/cloud-toolbox/blob/master/docs/version_history.md)
