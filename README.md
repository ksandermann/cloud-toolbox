# cloud-toolbox
Docker Image to work with Azure, AWS, Docker, Kubernetes, Openshift, Helm, Ansible and Terraform.
This is basically the toolchain I am working with on a daily basis, packed into a docker image to have a 
platform-independent development environment.
Feel free to use/share/contribute.

# Versioning 
Release tags will be build following pattern YYYY-MM-dd-version.
Version 1.0 of a date will always contain the latest stable/official versions of tooling available.
Other versions of a date can contain version combinations of the toolchain and will be documented in the version history
below.

## Version history
| RELEASE       | UBUNTU | DOCKER   | KUBECTL  | OC CLI | HELM   | TERRAFORM | AWS CLI  | AZ CLI | ANSIBLE | JINJA2 | OPENSSH | TILLER_NAMESPACE |
|---------------|--------|----------|----------|--------|--------|-----------|----------|--------|---------|--------|---------|------------------|
| 2019-07-25_01 | 18.04  | 18.09.08 | 1.15.1   | 3.11   | 2.14.2 | 0.12.4    | 1.16.198 | 2.0.69 | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
| 2019-07-18_01 | 18.04  | 18.09.08 | 1.15.0   | 3.11   | 2.14.2 | 0.12.4    | 1.16.198 | 2.0.69 | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
| 2019-07-17_01 | 18.04  | N/A      | 1.15.0   | 3.11   | 2.14.2 | 0.12.4    | 1.16.198 | 2.0.69 | 2.8.2   | 2.10   | 8.0p1   | kubetools        |
