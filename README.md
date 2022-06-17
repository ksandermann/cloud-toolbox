# cloud-toolbox
Docker Image to work with Azure, AWS, Google Cloud, Docker, Kubernetes, Openshift, Helm, Ansible, Terraform and HashiCorp Vault.
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

# terraform <=0.14 and >=0.15
While a lot of projects and workspaces have already been upgraded to terraform >= 0.15, terraform 0.14 remains necessary to ugprade old workspaces.
0.14 can be used via binary `terraform14`, while 1 is available via binary `terraform`.

# versioning
Release tags will be build following pattern YYYY-MM-dd-version.
Version 01 of a date will always contain the latest stable/official versions of tooling available.
Other versions of a date can contain version combinations of the toolchain and will be documented in the version history
below.

## version history
latest -> 2022-06-16_01

project -> 2022-06-16_01


| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI  | HELM   | TERRAFORM | AWS CLI | AZ CLI | GCLOUD SDK | ANSIBLE | JINJA2 | OPENSSH | CRICTL | VAULT  | VELERO | SENTINEL |
|---------------|--------|----------|----------|---------|--------|-----------|---------|--------|------------|---------|--------|---------|--------|--------|--------|----------|
| 2022-06-16_01 | 20.04  | 20.10.17 | 1.24.1   | 4.10.17 | 3.9.0  | 1.2.3     | 1.25.9  | 2.37.0 | 390.0.0    | 5.9.0   | 3.1.2  | 9.0p1   | 1.24.2 | 1.10.4 | 1.8.1  |  0.18.11 |
| 2022-05-02_01 | 20.04  | 20.10.14 | 1.23.6   | 4.10.10 | 3.8.2  | 1.1.9     | 1.23.4  | 2.36.0 | 383.0.1    | 5.7.0   | 3.1.2  | 9.0p1   | 1.23.0 | 1.10.2 | 1.8.1  |  0.18.9  |
| 2022-04-26_01 | 20.04  | 20.10.14 | 1.23.6   | 4.10.9  | 3.8.2  | 1.1.9     | 1.23.0  | 2.36.0 | 382.0.0    | 5.6.0   | 3.1.1  | 9.0p1   | 1.23.0 | 1.10.1 | 1.8.1  |  0.18.9  |
| 2022-03-17_01 | 20.04  | 20.10.13 | 1.23.5   | 4.10.3  | 3.8.1  | 1.1.7     | 1.22.76 | 2.34.1 | 377.0.0    | 5.5.0   | 3.0.3  | 8.9p1   | 1.23.0 | 1.9.4  | 1.8.1  |  0.18.7  |

## [ version history before 2022-03-17](https://github.com/ksandermann/cloud-toolbox/blob/master/docs/version_history.md)
