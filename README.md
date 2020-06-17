[![OKD](https://img.shields.io/badge/okd-4--4--0--okd--2020--05--23--beta--5-red.svg)](https://www.okd.io) [![Fedore CoreOS](https://img.shields.io/badge/fcos-31.20200517.3.0-blue.svg)](https://getfedora.org/en/coreos?stream=stable) [![CentOS](https://img.shields.io/badge/centos-7.8.2003-orange.svg)](https://www.centos.org/) [![KVM/QEMU](https://img.shields.io/badge/kvm%2Fqemu-0.12.0-red.svg)](https://www.linux-kvm.org/) [![Terraform](https://img.shields.io/badge/terraform-0.12.26-blueviolet.svg)](https://www.terraform.io/) [![Packer](https://img.shields.io/badge/packer-1.6.0-blueviolet.svg)](https://www.packer.io/) [![Ansible](https://img.shields.io/badge/ansible-2.9.9-red.svg)](https://www.ansible.com/)

# ODK-LAB: Controlled Environment for OKD4 experiments

You plan a dedicated machine to install and experiment with the [Community Distribution of Kubernetes](https://www.okd.io/), maybe even on an rented root server in the wild wild world?

It is probably worth the time to read a little further....

Naturally when we do some experiments we can destroy our cluster and bring it in a state we can't fix or recover. From this point of view we should try to keep complex things __simple and repeatable__. This is what this lab wants to address to.

You can expect a fully virtualized small IT center with everything you need to install a `User Provisioned Installation of OKD4` based on KVM. You get some great [Rook Cloud-native Storage](https://rook.io/) for your cluster and many more.

Additionally you get mostly all you need for a development environment including git, artifact management, private container registry, centralized user registries..... everything pre-configured and tightly integrated.

* * *

## Prerequisites

- Dedicated root server (recommended)
- Internet access*
- Git client (optional)
- SSH / VNC client
- [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) (optional but highly recommended!)
- [Red Hat Account](https://www.redhat.com/en) (to obtain a free of charge pull secret)

This project is being developed on a [Hetzner](https://www.hetzner.com) machine with the following specs:

- AMD Ryzen 9 3900 12-Core
- 128 GB DDR4 ECC
- 2 x 1,92 TB NVMe SSD

You can do it with less but than you have to [tweak some settings and/or strip off some optional services](docs/02_sizing.md).

*Please Note! __NO proxy support__ in this version! Following soon.

* * *

## Installation

__95% of the installation process is copy&paste. No deep Linux or OKD4/Kubernetes skills needed!*__

- [Install CentOS 7.8](docs/00_install_centos.md)
- [Install - lab.okd.example.com](docs/01_install_lab.md)
- [Provision infrastructure](docs/02_provision_infrastructure.md)
- [Install OKD4](docs/03_install_okd.md)

*The missing 5% are a guided [CentOS 7.8](docs/00_install_centos.md) Linux installation and using a Browser to obtain and store some secrets. And of course, using a Linux Terminal and SSH :-)

* * *

## What's in the box?

100% Open Source! Watch a [animated gif on dropbox](https://www.dropbox.com/s/8afoyovx6mtaiqf/OKD-LAB.gif?dl=0) and open pandorra's box.

Lab Machine:

- [Centos 7.8](https://www.centos.org/)
- [KVM](https://www.linux-kvm.org) / [QEMU](https://www.qemu.org)

Provisioning and automation:

- [Terraform](https://www.terraform.io)
- [Ansible](https://www.ansible.com/)
- [Packer](https://www.packer.io/)

Bastion (KVM):

- [Docker](https://www.docker.com/)
- [GitLab](https://about.gitlab.com/)
- [Artifactory](https://jfrog.com/open-source/)
- [Portainer](https://www.portainer.io)
- [Keycloak](https://www.keycloak.org/)
- [OpenLDAP](https://www.openldap.org/)
- [Project Quay](https://www.projectquay.io/)
- [OKD4](https://www.okd.io) installation environment:
  - Mirrored OKD4 Container Registry
  - Mirrored Fedora CoreOS
  - DNS
  - DHCP
  - TFTP

Load Balancer (KVM):

- [HAProxy](https://www.haproxy.org/)

[OKD4](https://www.okd.io) (KVMs):

- Bootstrap
- 3x Master
- 3x Worker

OKD4 Storage:

- [Rook Cloud-native Storage](https://rook.io/)

* * *

## A few words

This guide is not about installing and maintaining Linux at the highest possible levels. It's not about being the best of class automation expert. And it's a controlled environment with intentionally 95% static settings. But if you know what you do, you can change and expand  everything with ease and apply it to your needs. Have fun!

Thanks to all in the Open Source Community and especially to [@cgruver](https://github.com/cgruver) for [inspiration](https://github.com/cgruver/okd4-upi-lab-setup) and help!

* * *

## License

OKD-LAB is released under the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) license. See the [LICENSE](https://github.com/disposab1e/okd-lab/blob/master/LICENSE) file for details.
