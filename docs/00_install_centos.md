# Install CentOS 8.4

These Screenshots will guide you through a typical CentOS 8.4 installation. If you follow the Hetzner path, you can easily start a [CentOS 8.4 installation with Hetzner](hetzner.md).


## Welcome to Centos

Choose your preferred installation language.

![Welcome to Centos](images/centos/01.png)

## Installation Summary

![Installation Summary](images/centos/02.png)

## Keyboard Layout

Choose your preferred keyboard layout.

![Keyboard Layout](images/centos/03.png)

## Date & Time

Choose your timezone.

![Date & Time](images/centos/04.png)

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

Set IPv6 to `Link-Lokal Only`.

![Network & Hostname](images/centos/09.png)

## Software Selection

- Minimal Install

![Software Selection](images/centos/10.png)

## Installation Destination

This example assumes two hard drives for a `software raid` system with LVM. Apply it to your needs.

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

![Configure Volume Group - swap](images/centos/16.png)

![Configure Volume Group - root](images/centos/17.png)

### Installation Summary

![Installation Summary](images/centos/18.png)

## Root Password

![ Root Password](images/centos/19.png)

### Create User

Attention! __DO NOT__ use a different User name!

![User Settings](images/centos/20.png)

### Begin Installation

![Create User](images/centos/21.png)


![Installation progress](images/centos/22.png)

## Reboot

![Reboot](images/centos/23.png)

* * *

Next > [Setup - lab.okd.example.com](01_setup_lab.md)
