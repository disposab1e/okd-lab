# Provision infrastructure

< Prerequisite: [Install - lab.okd.example.com](01_setup_lab.md)

* * *

## Clone `okd-lab`

```bash
[lab@lab]

cd ~/
git clone https://github.com/disposab1e/okd-lab.git

```

...or connect with [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) and the [Remote - SSH extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) and clone from there.

## Initialize default virtualization environment

Switch to VNC and GNOME Desktop and start the "Virtual Machine Manager" graphical user interface.

- Activities - Show Applications - Virtual Machine Manager

This small application is a great viewer for the next steps __and__ additionally a convenient way to initialize and check the default virtualization environment. It will also create the default network and storage pool.

![Virtual Machine Manager - Start](images/vmm/00.png)

![Virtual Machine Manager - GUI](images/vmm/01.png)

## Install automation software

Install Packer, Terraform, Ansible Collections and generate SSH key for `lab` user.

```bash
[lab@lab]

ansible-playbook -K ~/okd-lab/ansible/lab/automation.yml

```

## Configure the `lab` 

Please change these settings to fit your needs!

`[ lab@lab ~/okd-lab/ansible/vars/vars.yaml ]`

```yaml

    # Your/Provider DNS Server
    okd_lab_bind_forwarder: '213.133.98.98'

    # Your/Provider NTP Server
    okd_lab_ntp_forwarder: 'ntp1.hetzner.de'

```

## Sizing the `lab`

__It is time to think about sizing! Please [check the defaults and change them as needed](02_sizing.md).__

## Build `bastion` VM

```bash
[lab@lab]

cd ~/okd-lab/packer/bastion
packer build -force bastion.json
mv ~/okd-lab/packer/bastion/output-bastion/bastion.qcow2 /tmp/

```

## Build `lb` VM

```bash
[lab@lab]

cd ~/okd-lab/packer/lb
packer build -force lb.json
mv ~/okd-lab/packer/lb/output-lb/lb.qcow2 /tmp/

```

## KVM Network

```bash
[lab@lab]

ansible-playbook -K ~/okd-lab/ansible/lab/network.yml

```

## Provision `bastion` host

```bash
[lab@lab]

cd ~/okd-lab/terraform/bastion
terraform init
terraform apply -auto-approve

```

## Provision `lb` host

```bash
[lab@lab]

cd ~/okd-lab/terraform/lb
terraform init
terraform apply -auto-approve

```

## Stroll around

It is time to reap the first fruits.

Start Firefox and import bookmarks some `~/okd-lab/bookmarks.json`

Have a look at the [Appendix](99_appendix.md) for detailed information.

## Import Bookmarks in Firefox


* * *

Next > [Install OKD4](03_install_okd.md)
