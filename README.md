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

# helm 3 and terraform 0.13/0.14
While a lot of projects are upgrading to helm 3, helm 2 will probably still be around for some time.
As helm 3 does not provide backward-compatibility, both versions are installed in parallel in cloud-toolbox.
Helm 2 can be used as before via binary `helm2`, while helm3 can be natively used using `helm`.
The same pattern applies to terraform 0.12 and 0.14 - 0.12 can be used via binary `terraform12`, while 0.14 is available via binary `terraform`.

# versioning
Release tags will be build following pattern YYYY-MM-dd-version.
Version 01 of a date will always contain the latest stable/official versions of tooling available.
Other versions of a date can contain version combinations of the toolchain and will be documented in the version history
below.

## version history
latest -> 2021-03-09_01
project -> 2021-03-09_01


| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI | HELM2    | HELM   | TERRAFORM | AWS CLI  | AZ CLI | GCLOUD SDK | ANSIBLE | JINJA2 | OPENSSH | CRICTL | VAULT | VELERO | SENTINEL |
|---------------|--------|----------|----------|--------|----------|--------|-----------|----------|--------|------------|---------|--------|---------|--------|-------|--------|----------|
| 2021-04-04_01 | 20.04  | 20.10.5  | 1.20.5   | 4.6    | 2.17.0   | 3.5.3  | 0.14.9    | 1.19.44  | 2.21.0 | 334.0.0    | 3.2.0   | 2.11.3 | 8.5p1   | 1.20.0 | 1.7.0 | 1.5.4  |  0.18.0  |
| 2021-03-18_01 | 20.04  | 20.10.5  | 1.20.4   | 4.6    | 2.17.0   | 3.5.3  | 0.14.7    | 1.19.30  | 2.20.0 | 332.0.0    | 3.1.0   | 2.11.3 | 8.5p1   | 1.20.0 | 1.6.3 | 1.5.3  |  0.17.4  |
| 2021-03-09_01 | 20.04  | 20.10.5  | 1.20.4   | 4.6    | 2.17.0   | 3.5.2  | 0.14.7    | 1.19.23  | 2.20.0 | 330.0.0    | 3.0.0   | 2.11.3 | 8.5p1   | 1.20.0 | 1.6.3 | 1.5.3  |    N/A   |
| 2021-01-31_01 | 20.04  | 20.10.2  | 1.20.2   | 4.6    | 2.17.0   | 3.5.1  | 0.14.5    | 1.18.223 | 2.18.0 | 325.0.0    | 2.10.6  | 2.11.2 | 8.4p1   | 1.20.0 | 1.6.2 |   N/A  |    N/A   |
| 2021-01-31_02 | 20.04  | 20.10.2  | 1.18.15  | 4.6    | 2.17.0   | 3.5.1  | 0.14.5    | 1.18.223 | 2.18.0 | 325.0.0    | 2.10.6  | 2.11.2 | 8.4p1   | 1.20.0 | 1.6.2 |   N/A  |    N/A   |
| 2021-01-03_01 | 20.04  | 20.10.1  | 1.20.1   | 4.6    | 2.17.0   | 3.4.2  | 0.14.3    | 1.18.207 | 2.17.0 | 321.0.0    | 2.10.4  | 2.11.2 | 8.4p1   | 1.19.0 | 1.6.1 |   N/A  |    N/A   |
| 2021-01-03_02 | 20.04  | 20.10.1  | 1.18.14  | 4.6    | 2.17.0   | 3.4.2  | 0.14.3    | 1.18.207 | 2.17.0 | 321.0.0    | 2.10.4  | 2.11.2 | 8.4p1   | 1.19.0 | 1.6.1 |   N/A  |    N/A   |

## [ version history before 2021-01-03](https://github.com/ksandermann/cloud-toolbox/blob/master/docs/version_history.md)
