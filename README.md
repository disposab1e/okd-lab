[![OKD](https://img.shields.io/badge/okd-4.7.0--0.okd--2021--04--24--103438-red.svg)](https://www.okd.io) [![Fedore CoreOS](https://img.shields.io/badge/fcos-33.20210328.3.0-blue.svg)](https://getfedora.org/en/coreos?stream=stable) [![Rook](https://img.shields.io/badge/rook-1.5.9-blue.svg)](https://rook.io/) [![CentOS](https://img.shields.io/badge/centos-8.3.2011-orange.svg)](https://www.centos.org/) [![Terraform](https://img.shields.io/badge/terraform-0.13.6-blueviolet.svg)](https://www.terraform.io/) [![Packer](https://img.shields.io/badge/packer-1.7.0-blueviolet.svg)](https://www.packer.io/) [![Ansible](https://img.shields.io/badge/ansible-2.9.18-red.svg)](https://www.ansible.com/)


# OKD-LAB: Controlled Environment for OKD4 experiments

You plan a dedicated machine to install and experiment with the [Community Distribution of Kubernetes](https://www.okd.io/), maybe even on an rented root server in the wild wild world?

It is probably worth the time to read a little further....

Naturally when we do some experiments we can destroy our cluster and bring it in a state we can't fix or recover. From this point of view we should try to keep complex things __simple and repeatable__. This is what this lab wants to address to.

You can expect a fully virtualized small IT center with everything you need to install a `User Provisioned Infrastructure (UPI)` of [OKD4](https://www.okd.io/) based on [KVM](https://www.linux-kvm.org). 

Additionally you get mostly all you need for a development environment including git, artifact management, private container registry, centralized user registry..... everything pre-configured and tightly integrated.

* * *

## OKD-LAB: Overview

![OKD-LAB Overview](docs/images/okd-lab.png)

* * *

## Prerequisites

- Dedicated root server (recommended)
- Internet access*
- Git client (optional)
- SSH / VNC client
- [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) (optional but highly recommended!)

This project is being developed on a [Hetzner](https://www.hetzner.com) machine with the following specs:

- AMD Ryzen 9 3900 12-Core
- 128 GB DDR4 ECC
- 2 x 1,92 TB NVMe SSD

You can do it with less but than you have to [tweak some settings and/or strip off some optional services](docs/02_sizing.md).

*Please Note! __NO proxy support__ in this version! Following soon.

* * *

## Installation

__95% of the installation process is copy&paste. No deep Linux or OKD4/Kubernetes skills needed!*__

- [Install CentOS 8.3](docs/00_install_centos.md)
- [Setup - lab.okd.example.com](docs/01_setup_lab.md)
- [Provision infrastructure](docs/02_provision_infrastructure.md)
- [Install OKD4](docs/03_install_okd.md)

*The missing 5% is a guided [CentOS 8.3](docs/00_install_centos.md) Linux installation and using a Firefox to create some tokens.

* * *

## What's in the box?

100% Open Source! Watch a [animated gif at dropbox](https://www.dropbox.com/s/p8alcwdx07jsevq/OKD-LAB.gif?dl=0) and open pandorra's box.

Lab Machine:

- [Centos 8.3](https://www.centos.org/)
- [KVM](https://www.linux-kvm.org) / [QEMU](https://www.qemu.org)

Provisioning and automation:

- [Terraform](https://www.terraform.io)
- [Packer](https://www.packer.io/)
- [Ansible](https://www.ansible.com/)

Bastion (KVM):

- [OKD4](https://www.okd.io) - UPI installation environment:
  - OKD4 Registry Mirror
  - Fedora CoreOS Mirror
  - NTP
  - DNS
  - DHCP
  - TFTP
- [Project Quay](https://www.projectquay.io/) with [Clair](https://github.com/quay/clair)
- [Podman](https://podman.io/), [Skopeo](https://github.com/containers/skopeo), [Buildah](https://github.com/containers/buildah/) (no Docker!)
- [389 Directory](https://directory.fedoraproject.org/)
- [GitLab](https://about.gitlab.com/) (optional)
- [Artifactory](https://jfrog.com/open-source/) (optional)

Load Balancer (KVM):

- [HAProxy](https://www.haproxy.org/)

[OKD4](https://www.okd.io) (KVMs):

- Bootstrap
- 3x Master
- 3x Worker

[OKD4](https://www.okd.io) Storage:

- [Rook Cloud-native Storage](https://rook.io/)

* * *

## What do you get from the OKD world?

- 3x Master and 3x Worker
- Chrony time services configured on all Master and Worker nodes
- Access to trusted private Project Quay container registry 
- Trusted custom Certificate Authority and SSL certificates for Web console, Router, API, LDAP, Project Quay, Podman etc.
- LDAP(s) authorization provider with:
  * Administrators: `admin`, `lab` in the `cluster-admin` role
  * Team Members: `awesome-admin`, `awesome-developer`
- Labeled nodes:
  * Master [`master`, `infra`, `worker`]
  * Worker [`worker`, `storage-node`]
- Routers sticked to `infra` nodes
- Enabled `Image Pruner` and disabled `Samples Operator`
- User kubeadmin is removed [optional]
- Enhanced DockerHub rate limit [optional]
- [Rook Cloud-native Storage](https://rook.io/) [optional]

* * *

## Security

Especially with servers available in the wild wild world some kind of security makes sense!

For this reason:
  
  * A Firewall is running on this lab and only SSH (port 53) is allowed on the external interface.
  * Only SSH PubkeyAuthentication is allowed.
  * Only necessary services are enabled.
  * Except SSH all network services are bound to `localhost`.
  * Virtual network is not directly reachable from the wild world.
  * VS Code and VNC is only available via SSH tunnel.

If you go the Hetzner path [additional security](docs/00_hetzner.md) is possible and recommended.

* * *

## A few words

This guide is not about installing and maintaining Linux at the highest possible levels. It's not about being the best of class automation expert and it's a controlled environment with intentionally 99% static settings. But if you know what you do, you can change and expand  everything with ease and apply it to your needs. Have fun!

Thanks to all in the Open Source Community and especially to [@cgruver](https://github.com/cgruver) for [inspiration](https://github.com/cgruver/okd4-upi-lab-setup) and help!


* * *

## License

OKD-LAB is released under the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) license. See the [LICENSE](https://github.com/disposab1e/okd-lab/blob/master/LICENSE) file for details. Some components may be licensed differently - consult individual repositories for more.
