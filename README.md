# cloud-toolbox
Docker Image to work with Azure, AWS, Docker, Kubernetes, Openshift, Helm, Ansible, kops and Terraform.
It's the toolchain I'm working with on a daily basis, packed into a docker image with both zsh and bash to have a 
platform-independent development environment.
Feel free to use/share/contribute.

# default shell & custom startup-script
The default shell is sh.
However, the CMD step inside the Dockerfile as well as the default command inside run.sh points to /bin/zsh.
By default, the file .autoexec.sh will be mounted into the container and sourced inside both bash and zsh.

# custom ca certificates
All CAs placed inside ```~/ca-certificates``` will be mounted into the container and trusted on startup.

# Versioning 
Release tags will be build following pattern YYYY-MM-dd-version.
Version 1.0 of a date will always contain the latest stable/official versions of tooling available.
Other versions of a date can contain version combinations of the toolchain and will be documented in the version history
below.

## Version history
| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI | HELM   | TERRAFORM | AWS CLI  | AZ CLI | KOPS   | ANSIBLE | JINJA2 | OPENSSH | TILLER_NAMESPACE |
|---------------|--------|----------|----------|--------|--------|-----------|----------|--------|--------|---------|--------|---------|------------------|
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
