<p align="center">
 <img width="100px" src="https://res.cloudinary.com/anuraghazra/image/upload/v1594908242/logo_ccswme.svg" align="center" alt="GitHub Readme Stats" />
 <h2 align="center">GitHub Readme Stats</h2>
 <p align="center">Get dynamically generated GitHub stats on your READMEs!</p>
</p>
  <p align="center">
    <a href="https://github.com/anuraghazra/github-readme-stats/actions">
      <img alt="Tests Passing" src="https://github.com/anuraghazra/github-readme-stats/workflows/Test/badge.svg" />
    </a>
    <a href="https://github.com/anuraghazra/github-readme-stats/graphs/contributors">
      <img alt="GitHub Contributors" src="https://img.shields.io/github/contributors/anuraghazra/github-readme-stats" />
    </a>
    <a href="https://codecov.io/gh/anuraghazra/github-readme-stats">
      <img src="https://codecov.io/gh/anuraghazra/github-readme-stats/branch/master/graph/badge.svg" />
    </a>
    <a href="https://github.com/anuraghazra/github-readme-stats/issues">
      <img alt="Issues" src="https://img.shields.io/github/issues/anuraghazra/github-readme-stats?color=0088ff" />
    </a>
    <a href="https://github.com/anuraghazra/github-readme-stats/pulls">
      <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/anuraghazra/github-readme-stats?color=0088ff" />
    </a>
    <br />
    <br />
    <a href="https://a.paddle.com/v2/click/16413/119403?link=1227">
      <img src="https://img.shields.io/badge/Supported%20by-VSCode%20Power%20User%20%E2%86%92-gray.svg?colorA=655BE1&colorB=4F44D6&style=for-the-badge"/>
    </a>
    <a href="https://a.paddle.com/v2/click/16413/119403?link=2345">
      <img src="https://img.shields.io/badge/Supported%20by-Node%20Cli.com%20%E2%86%92-gray.svg?colorA=61c265&colorB=4CAF50&style=for-the-badge"/>
    </a>
  </p>

  <p align="center">
    <a href="#demo">View Demo</a>
    ·
    <a href="https://github.com/anuraghazra/github-readme-stats/issues/new/choose">Report Bug</a>
    ·
    <a href="https://github.com/anuraghazra/github-readme-stats/issues/new/choose">Request Feature</a>
    ·
    <a href="https://github.com/anuraghazra/github-readme-stats/discussions">Ask Question</a>
  </p>
  <p align="center">
    <a href="/docs/readme_fr.md">Français </a>
    ·
    <a href="/docs/readme_cn.md">简体中文</a>
    ·
    <a href="/docs/readme_es.md">Español</a>
    ·
    <a href="/docs/readme_de.md">Deutsch</a>
    ·
    <a href="/docs/readme_ja.md">日本語</a>
    ·
    <a href="/docs/readme_pt-BR.md">Português Brasileiro</a>
    ·
    <a href="/docs/readme_it.md">Italiano</a>
    ·
    <a href="/docs/readme_kr.md">한국어</a>
    .
    <a href="/docs/readme_nl.md">Nederlands</a>
    .
    <a href="/docs/readme_np.md">नेपाली</a>
    .
    <a href="/docs/readme_tr.md">Türkçe</a>
  </p>
</p>


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

| RELEASE              | UBUNTU | DOCKER   | KUBECTL | HELM   | TERRAFORM | AZ CLI | OPENSSH | CRICTL | VELERO | SENTINEL | STERN  | KUBELOGIN | OC CLI | AWS CLI | GCLOUD SDK  | ANSIBLE | JINJA2  | VAULT  |
|----------------------|--------|----------|---------|--------|-----------|--------|---------|--------|--------|----------|--------|-----------|--------|---------|-------------|---------|---------|--------|
| 2022-10-06_complete  | 20.04  | 20.10.18 | 1.25.2  | 3.10.0 | 1.3.1     | 2.40.0 | 9.1p1   | 1.25.0 | 1.9.2  | 0.18.12  | 1.22.0 | 0.0.20    | 4.11.6 | 1.25.88 | 402.0.0     | 6.4.0   | 3.1.2   | 1.11.4 |

## version history
## [version history before 2022-10-05](https://github.com/ksandermann/cloud-toolbox/blob/master/docs/version_history.md)


TODO
uncomment sleep
remove test tags
add binary checks
remove plain output
update to current date
change branch & PR
