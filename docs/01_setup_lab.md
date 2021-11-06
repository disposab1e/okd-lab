# Setup - lab.okd.example.com

< Prerequisite: [Install Centos 8.4](00_install_centos.md)

* * *

Typically this is a one time installation. Not to much automation here, just follow step by step with `copy&paste`.

## Clone `okd-lab`

Clone this project to your home desktop e.g. your user home directory.

```bash
[home@home]

cd ~/
git clone https://github.com/disposab1e/okd-lab.git

```

## Prepare docs (optional)

To follow the __copy&paste__ style of this guide it can  be useful to set the IP address of your host to some commands. Just use your favorite tool and replace `YO.UR.I.P` in this `README.md` with your public IP address.

## SSH and user configuration

### Generate new SSH keys (or use an existing one)

Accept all settings and use NO passphrase.

```bash
[home@home]

ssh-keygen -f ~/.ssh/okd_lab_id_rsa

```

### Authorize public key

```bash
[home@home]

ssh-copy-id -i ~/.ssh/okd_lab_id_rsa.pub lab@YO.UR.I.P

```

### Configure SSH config

```bash
[home@home]

vi ~/.ssh/config

# Add to your existing file:

Host lab
  HostName YO.UR.I.P
  IdentityFile ~/.ssh/okd_lab_id_rsa
  User lab

Host bastion-lab
  HostName 10.0.0.2
  ProxyJump YO.UR.I.P
  User lab
  ForwardAgent yes

Host bastion-root
  HostName 10.0.0.2
  ProxyJump YO.UR.I.P
  User root
  ForwardAgent yes

```

## Configurations and installations

### SSH to `lab`

```bash
[home@home]

ssh lab@YO.UR.I.P

```

### Sudo without password

```bash
[lab@lab]

sudo tee -a /etc/sudoers << END
lab ALL=(ALL) NOPASSWD:ALL
END

```

### Update CentOS

```bash
[lab@lab]

sudo dnf -y update

```

### Restrict sshd to only allow PubkeyAuthentication for users (not root!)

```bash
[lab@lab]

sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sudo sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
sudo sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/g" /etc/ssh/sshd_config
sudo systemctl restart sshd

```

### Change password for user lab

```bash
[lab@lab]

sudo passwd lab

choose: lab

```

### Change password for user root

```bash
[lab@lab]

sudo passwd root

choose: root

```

### Install GNOME Desktop

```bash
[lab@lab]

sudo dnf -y groupinstall "Server with GUI"

```

### Install VNC client and server

```bash
[lab@lab]

sudo dnf -y install tigervnc tigervnc-server

```

### Prepare VNC service for user lab

```bash
[lab@lab]

sudo bash -c 'cat << EOF > /etc/tigervnc/vncserver.users
:1=lab
EOF'

sudo bash -c 'cat << EOF > /etc/tigervnc/vncserver-config-defaults
session=gnome
alwaysshared
localhost
geometry=2560x1440    
EOF'

```

### Set VNC password

```bash
[lab@lab]

vncpasswd

choose: vnclab

Choose "n" at the end

```

### Start and enable VNC server

```bash
[lab@lab]

sudo systemctl enable --now vncserver@:1

```

### Default login via GNOME Desktop

```bash
[lab@lab]

sudo ln -sf /lib/systemd/system/runlevel3.target /etc/systemd/system/default.target

```

### Disable unused services

```bash
[lab@lab]

sudo systemctl stop cups
sudo systemctl disable cups
sudo systemctl mask cups

sudo systemctl stop rpcbind
sudo systemctl disable rpcbind
sudo systemctl mask rpcbind
sudo systemctl stop rpcbind.socket
sudo systemctl disable rpcbind.socket
sudo systemctl mask rpcbind.socket

sudo systemctl stop avahi-daemon
sudo systemctl disable avahi-daemon
sudo systemctl mask avahi-daemon

sudo systemctl stop ModemManager
sudo systemctl disable ModemManager
sudo systemctl mask ModemManager

sudo systemctl disable bluetooth
sudo systemctl mask bluetooth

sudo systemctl stop geoclue
sudo systemctl disable geoclue
sudo systemctl mask geoclue

sudo systemctl stop mcelog
sudo systemctl disable mcelog
sudo systemctl mask mcelog

sudo systemctl stop kdump
sudo systemctl disable kdump
sudo systemctl mask kdump

sudo systemctl stop mdmonitor
sudo systemctl disable mdmonitor
sudo systemctl mask mdmonitor

```

### Remove dhcpv6-client from firewall

```bash
[lab@lab]

sudo firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --list-all

```

### Install and configure Cockpit

```bash
[lab@lab]

sudo dnf -y install cockpit cockpit-machines cockpit-networkmanager

sudo systemctl enable cockpit.socket

sudo mkdir /etc/systemd/system/cockpit.socket.d

sudo bash -c 'cat << EOF > /etc/systemd/system/cockpit.socket.d/listen.conf
[Socket]
ListenStream=
ListenStream=127.0.0.1:9090
EOF'

sudo systemctl daemon-reload
sudo systemctl restart cockpit.socket

```

### Remove cockpit from firewall

```bash
[lab@lab]

sudo firewall-cmd --permanent --zone=public --remove-service=cockpit
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --list-all

```

### Install Virtualization Clients

```bash
[lab@lab]

sudo dnf -y install @virtualization-client

```

### Add `lab` user to group `libvirt`

```bash
[lab@lab]

sudo usermod -aG libvirt lab
newgrp libvirt

```

### Install Ansible and Git

```bash
[lab@lab]

sudo dnf -y install epel-release

sudo dnf -y install ansible git git-lfs

```

### Final checks

```bash
[lab@lab]

sudo dnf -y install nmap

sudo lsof -n -i TCP| fgrep LISTEN
nmap -sT YO.UR.I.P
sudo nmap -sU YO.UR.I.P

```

## Reboot

```bash
[lab@lab]

sudo reboot

```

## Open a VNC tunnel and connect with VNC client

```bash
[home@home]

ssh -C -L 0.0.0.0:5901:localhost:5901 -N lab@YO.UR.I.P

```

## Setup GNOME Desktop

- System Tools Settings: Power - Never Blank Screen
- System Tools Settings: Privacy - Screen Lock - Off

* * *

Next > [Provision infrastructure](02_provision_infrastructure.md)
