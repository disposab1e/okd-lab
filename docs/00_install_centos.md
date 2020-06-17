# Install CentOS 7.8

These Screenshots will guide you through a typical CentOS 7.8 installation. If you follow the Hetzner path you can easily start a [CentOS 7.8 installation with Hetzner](00_hetzner.md).

## Welcome to Centos

Choose your preferred installation process language.

![Welcome to Centos](images/centos/01.png)

## Installation Summary

![Installation Summary](images/centos/02.png)

## Keyboard Layout

Choose your preferred keyboard layout.

![Keyboard Layout](images/centos/03.png)

## Date & Time

Choose your timezone and add a custom NTP server. Disable the default NTP servers.

![Date & Time](images/centos/04.png)

![Date & Time](images/centos/05.png)

## Kdump

Disable kdump for now, it can be activated later if really needed.

![Kdump](images/centos/06.png)

## Security Policy

Don't apply any security policies.

![Security Policy](images/centos/07.png)

## Network & Hostname

Hostname: `lab.okd.example.com`

Attention! __DO NOT__ use a different hostname!

![Network & Hostname](images/centos/08.png)

Diable (ignore) IPv6 so you don't have to care about IPv6 network security.

![Network & Hostname](images/centos/09.png)

## Software Selection

- Virtualization Host
  - Virtualization Platform
  - System Administration Tools

![Software Selection](images/centos/10.png)

## Installation Destination

This example assumes you have two hard drives available and you want to build a software raid system with LVM. Apply it to your needs. We recommend only boot, swap and root partitions typically based on LVM.

![Installation Destination](images/centos/11.png)

### Manual partitioning

`Click here to create them automatically` is a good starting point.

![Manual partitioning](images/centos/12.png)

![Manual partitioning](images/centos/13.png)

### Boot partition

Remove everything instead of the `boot` partition. Change the boot partition to `RAID0`.

![Boot partition](images/centos/14.png)

### Swap partition

![Swap partition](images/centos/15.png)

### Configure Volume Group for swap & root partitions

Don't forget to also choose `RAID0` here.

![Configure Volume Group](images/centos/16.png)

![Configure Volume Group](images/centos/17.png)

### Root partition

![Root partition](images/centos/18.png)

## Begin Installation

![Begin Installation](images/centos/19.png)

## User Settings

![User Settings](images/centos/20.png)

### Root Password

![Root Password](images/centos/21.png)

### Create User

Attention! __DO NOT__ use a different User name!

![Create User](images/centos/22.png)

## Reboot

![Reboot](images/centos/23.png)

* * *

Next > [Install - lab.okd.example.com](01_install_lab.md)
