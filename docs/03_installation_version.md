# Installation version

< [Install OKD4](03_install_okd.md)

* * *

You're free to decide which version to install (including [nightlies](https://origin-release.svc.ci.openshift.org/)). With UPI it's also possible to choose the Fedora CoreOS version.

`[ lab@lab ~/okd-lab/ansible/vars/vars.yaml ]`

```yaml

    # Unique name of this installation
    okd_lab_install_okd_name: '4-7-0-0-okd-2021-04-24-103438'

    # OKD installation version
    okd_lab_install_okd_version: 4.7.0-0.okd-2021-03-07-090821

    # Fedora CoreOS installation version and stream
    okd_lab_install_fcos_stream: 'stable' 
    okd_lab_install_fcos_version: '33.20210328.3.0'

```

Changing any of these settings requires a new setup of the installation environment:

```bash
[lab@lab]

# Cleanup OKD installation environment
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags env-cleanup

# Cleanup Fedorea CoreOS, PXE's and Registry
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/mirror.yml --tags cleanup

# Change your settings in ~/okd-lab/ansible/vars/vars.yaml

# Setup OKD installation environment
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags env-setup

# Mirror Fedorea CoreOS, PXE's and Registry Mirrors
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/mirror.yml --tags mirror

# Setup OKD Installer to use Registry Mirror
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags installer-setup

```


A typical workflow if you already have a cluster installed but want to install a new version:

```bash
[lab@lab]

# Destroy (unprovision) Cluster with Terraform
ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags destroy

# Cleanup OKD installation environment
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags env-cleanup

# Cleanup Fedorea CoreOS, PXE's and Registry Mirrors
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/mirror.yml --tags cleanup

# Change your settings in ~/okd-lab/ansible/vars/vars.yaml if you plan to install different versions

# Setup OKD installation environment
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags env-setup

# Mirror Fedorea CoreOS, PXE's and Registry
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/mirror.yml --tags mirror

# Setup OKD Installer to use Registry Mirror
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags installer-setup

# Remember kubeadmin password
ssh root@bastion "cat ~/installer/auth/kubeadmin-password" > ~/okd-lab/.secrets/kubeadmin

# Apply (provision) Cluster with Terraform
ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags apply

# Complete OKD installation
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/okd.yml --tags complete

# Destroy Bootstrap with Terraform
ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags bootstrap-destroy

# Day-1 OKD configurations
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/okd.yml --tags config

```