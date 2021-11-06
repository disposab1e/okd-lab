# Start CentOS 8.4 installation with Hetzner

< [Install Centos 8.4](00_install_centos.md)

* * *

## Prepare Firewall

Only SSH and ICMP will be allowed at the end. However, during VNC installation we additionally need an open VNC Port `5901`. This port should be removed after the VNC installation.

![Prepare Firewall](images/hetzner/01.png)

## Activate VNC installation

Don't forget to remember your password!

![Activate VNC installation](images/hetzner/02.png)

## Initiate Reboot

![Initiate Reboot](images/hetzner/03.png)

## Connect with VNC

Example:

```bash
[home@home]

vncviewer YO.U.R.IP:5901

```

## Remove VNC port from Firewall

After successful CentOS installation you should remove the VNC port from the firewall. VNC will be available later via SSH tunnel.

Plase Note! Define a `Source IP` (e.g. the IP range of your internet provider) for `ssh` to expand security.

![Finish Firewall](images/hetzner/04.png)

* * *

Next> [Install CentOS 8.4](00_install_centos.md)

