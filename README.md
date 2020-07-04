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
1. if no, start a new interactive container and start a new shell (/bin/zsh) inside it.

# custom ca certificates`
All CAs placed inside ```~/ca-certificates``` on the host system will be mounted into the container and trusted on startup.

# helm 2 and helm 3
While a lot of projects/customers are upgrading to helm 3, helm 2 will probably still be around for some time.
As helm 3 does not provide backward-compatibility, both versions are installed in parallel in cloud-toolbox.
Helm 2 can be used as before to provide backward-compatibility, helm 3 can be used via binary `helm3`. 

# versioning 
Release tags will be build following pattern YYYY-MM-dd-version.
Version 01 of a date will always contain the latest stable/official versions of tooling available.
Other versions of a date can contain version combinations of the toolchain and will be documented in the version history
below.

## version history
latest -> 2020-07-04_01
project -> 2020-07-04_02

| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI | HELM   | HELM3   | TERRAFORM | AWS CLI  | AZ CLI | GCLOUD SDK | KOPS   | ANSIBLE | JINJA2 | OPENSSH |
|---------------|--------|----------|----------|--------|--------|---------|-----------|----------|--------|------------|--------|---------|--------|---------|
| 2020-07-04_01 | 18.04  | 19.03.11 | 1.18.5   | 3.11   | 2.16.9 | 3.2.4   | 0.12.28   | 1.18.93  | 2.8.0  | 299.0.0    | 1.17.0 | 2.9.10  | 2.11.2 | 8.3p1   |
| 2020-07-04_02 | 18.04  | 19.03.11 | 1.16.12  | 3.11   | 2.16.1 | 3.2.4   | 0.12.28   | 1.18.93  | 2.8.0  | 299.0.0    | 1.17.0 | 2.9.10  | 2.11.2 | 8.3p1   |
| 2020-06-29_01 | 18.04  | 19.03.11 | 1.18.5   | 3.11   | 2.16.9 | 3.2.4   | 0.12.28   | 1.18.89  | 2.8.0  | 298.0.0    | 1.17.0 | 2.9.10  | 2.11.2 | 8.3p1   |
| 2020-06-29_02 | 18.04  | 19.03.11 | 1.16.12  | 3.11   | 2.16.1 | 3.2.4   | 0.12.28   | 1.18.89  | 2.8.0  | 298.0.0    | 1.17.0 | 2.9.10  | 2.11.2 | 8.3p1   |
| 2020-06-19_01 | 18.04  | 19.03.11 | 1.18.4   | 3.11   | 2.16.9 | 3.2.4   | 0.12.26   | 1.18.84  | 2.7.0  | 297.0.1    | 1.17.0 | 2.9.10  | 2.11.2 | 8.3p1   |
| 2020-06-19_02 | 18.04  | 19.03.11 | 1.16.10  | 3.11   | 2.16.1 | 3.2.4   | 0.12.26   | 1.18.84  | 2.7.0  | 297.0.1    | 1.17.0 | 2.9.10  | 2.11.2 | 8.3p1   |
| 2020-06-05_01 | 18.04  | 19.03.11 | 1.18.3   | 3.11   | 2.16.7 | 3.2.1   | 0.12.26   | 1.18.73  | 2.7.0  | 295.0.0    | 1.17.0 | 2.9.9   | 2.11.2 | 8.3p1   |


## version history before 2020-06-05

| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI | HELM   | HELM3   | TERRAFORM | AWS CLI  | AZ CLI | KOPS   | ANSIBLE | JINJA2 | OPENSSH |
|---------------|--------|----------|----------|--------|--------|---------|-----------|----------|--------|--------|---------|--------|---------|
| 2020-05-26_01 | 18.04  | 19.03.8  | 1.18.3   | 3.11   | 2.16.7 | 3.2.1   | 0.12.25   | 1.18.66  | 2.6.0  | 1.16.2 | 2.9.9   | 2.11.2 | 8.2p1   |
| 2020-05-26_02 | 18.04  | 19.03.8  | 1.16.10  | 3.11   | 2.16.1 | 3.2.1   | 0.12.25   | 1.18.66  | 2.6.0  | 1.16.2 | 2.9.9   | 2.11.2 | 8.2p1   |
| 2020-05-17_01 | 18.04  | 19.03.8  | 1.18.2   | 3.11   | 2.16.7 | 3.2.1   | 0.12.25   | 1.18.61  | 2.5.1  | 1.16.2 | 2.9.9   | 2.11.2 | 8.2p1   |
| 2020-05-17_02 | 18.04  | 19.03.8  | 1.16.9   | 3.11   | 2.16.1 | 3.2.1   | 0.12.25   | 1.18.61  | 2.5.1  | 1.16.2 | 2.9.9   | 2.11.2 | 8.2p1   |
| 2020-05-09_01 | 18.04  | 19.03.8  | 1.18.2   | 3.11   | 2.16.7 | 3.2.1   | 0.12.24   | 1.18.56  | 2.5.1  | 1.16.2 | 2.9.7   | 2.11.2 | 8.2p1   |
| 2020-05-09_02 | 18.04  | 19.03.8  | 1.15.12  | 3.11   | 2.16.1 | 3.2.1   | 0.12.24   | 1.18.56  | 2.5.1  | 1.16.2 | 2.9.7   | 2.11.2 | 8.2p1   |
| 2020-04-04_01 | 18.04  | 19.03.8  | 1.18.0   | 3.11   | 2.16.5 | 3.1.2   | 0.12.24   | 1.18.36  | 2.3.1  | 1.16.0 | 2.9.6   | 2.11.1 | 8.2p1   |
| 2020-04-04_02 | 18.04  | 19.03.8  | 1.15.11  | 3.11   | 2.16.1 | 3.1.2   | 0.12.24   | 1.18.36  | 2.3.1  | 1.16.0 | 2.9.6   | 2.11.1 | 8.2p1   |


## version history before 2020-04-04_01

| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI | HELM   | TERRAFORM | AWS CLI  | AZ CLI | KOPS   | ANSIBLE | JINJA2 | OPENSSH | TILLER_NAMESPACE |
|---------------|--------|----------|----------|--------|--------|-----------|----------|--------|--------|---------|--------|---------|------------------|
| 2020-03-02_01 | 18.04  | 19.03.6  | 1.17.3   | 3.11   | 2.16.3 | 0.12.21   | 1.18.12  | 2.1.0  | 1.16.0 | 2.9.5   | 2.11.1 | 8.2p1   | kubetools        |
| 2020-03-02_02 | 18.04  | 19.03.6  | 1.15.10  | 3.11   | 2.16.1 | 0.12.21   | 1.18.12  | 2.1.0  | 1.16.0 | 2.9.5   | 2.11.1 | 8.2p1   | N/A              |
| 2020-02-19_01 | 18.04  | 19.03.5  | 1.17.3   | 3.11   | 2.16.3 | 0.12.21   | 1.18.2   | 2.1.0  | 1.15.2 | 2.9.5   | 2.11.1 | 8.1p1   | kubetools        |
| 2020-02-19_02 | 18.04  | 19.03.5  | 1.15.10  | 3.11   | 2.16.1 | 0.12.20   | 1.18.2   | 2.1.0  | 1.15.1 | 2.9.4   | 2.11.1 | 8.1p1   | N/A              |
| 2020-02-04_01 | 18.04  | 19.03.5  | 1.17.2   | 3.11   | 2.16.1 | 0.12.20   | 1.17.10  | 2.0.81 | 1.15.1 | 2.9.4   | 2.11.1 | 8.1p1   | kubetools        |
| 2019-12-05_01 | 18.04  | 19.03.5  | 1.16.3   | 3.11   | 3.0.1  | 0.12.17   | 1.16.297 | 2.0.77 | 1.15.0 | 2.9.2   | 2.10.3 | 8.1p1   | kubetools        |
| 2019-11-10_01 | 18.04  | 19.03.4  | 1.16.2   | 3.11   | 2.16.0 | 0.12.13   | 1.16.278 | 2.0.76 | 1.14.1 | 2.9.0   | 2.10.3 | 8.1p1   | kubetools        |
| 2019-11-05_01 | 18.04  | 19.03.4  | 1.16.2   | 3.11   | 2.15.2 | 0.12.13   | 1.16.273 | 2.0.76 | 1.14.0 | 2.9.0   | 2.10.3 | 8.1p1   | kubetools        |
| 2019-09-19_01 | 18.04  | 19.03.2  | 1.16.0   | 3.11   | 2.14.3 | 0.12.9    | 1.16.239 | 2.0.73 | 1.13.0 | 2.8.5   | 2.10.1 | 8.0p1   | kubetools        |
| 2019-09-19_02 | 18.04  | 19.03.2  | 1.13.10  | 3.11   | 2.14.3 | 0.12.9    | 1.16.239 | 2.0.73 | 1.13.0 | 2.8.5   | 2.10.1 | 8.0p1   | kubetools        |
| 2019-09-17_01 | 18.04  | 19.03.2  | 1.15.3   | 3.11   | 2.14.3 | 0.12.8    | 1.16.239 | 2.0.73 | 1.13.0 | 2.8.5   | 2.10.1 | 8.0p1   | kubetools        |
| 2019-08-12_01 | 18.04  | 18.09.8  | 1.15.2   | 3.11   | 2.14.3 | 0.12.6    | 1.16.198 | 2.0.70 | 1.13.0 | 2.8.3   | 2.10.1 | 8.0p1   | kubetools        |
| 2019-08-12_02 | 18.04  | 18.09.8  | 1.13.7   | 3.11   | 2.14.3 | 0.12.6    | 1.16.198 | 2.0.70 | 1.13.0 | 2.8.3   | 2.10.1 | 8.0p1   | kubetools        |
| 2019-08-08_01 | 18.04  | 18.09.8  | 1.15.2   | 3.11   | 2.14.3 | 0.12.6    | 1.16.198 | 2.0.70 | 1.13.0 | 2.8.3   | 2.10.1 | 8.0p1   | kubetools        |
| 2019-07-30_01 | 18.04  | 18.09.8  | 1.15.1   | 3.11   | 2.14.2 | 0.12.5    | 1.16.198 | 2.0.69 | 1.12.2 | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
| 2019-07-30_02 | 18.04  | 18.09.8  | 1.12.8   | 3.11   | 2.14.2 | 0.12.5    | 1.16.198 | 2.0.69 | 1.12.2 | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
| 2019-07-28_01 | 18.04  | 18.09.8  | 1.15.1   | 3.11   | 2.14.2 | 0.12.5    | 1.16.198 | 2.0.69 | 1.12.2 | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
| 2019-07-25_01 | 18.04  | 18.09.8  | 1.15.1   | 3.11   | 2.14.2 | 0.12.4    | 1.16.198 | 2.0.69 | N/A    | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
| 2019-07-18_01 | 18.04  | 18.09.8  | 1.15.0   | 3.11   | 2.14.2 | 0.12.4    | 1.16.198 | 2.0.69 | N/A    | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
| 2019-07-17_01 | 18.04  | N/A      | 1.15.0   | 3.11   | 2.14.2 | 0.12.4    | 1.16.198 | 2.0.69 | N/A    | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
