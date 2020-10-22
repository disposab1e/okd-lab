# Installation version

< [Install OKD4](03_install_okd.md)

* * *

You're free to decide which version to install (including [nightlies](https://origin-release.svc.ci.openshift.org/)). With UPI it's also possible to choose the Fedora CoreOS version. It's recommended to give each installation version a unique `okd_lab_install_name`. With unique names existing installations and install environments will not be overwritten with new Container Registry e.g. and Fedora CoreOS mirrors.

`[ lab@lab ~/okd-lab/ansible/okd/01_setup.yml ]`

```yaml

---
- hosts: bastion
  vars:
    # Unique name of this installation
    okd_lab_install_name: '4-5-0-0-okd-2020-10-15-235428'

    # OKD installation version
    okd_lab_install_okd_version: 4.5.0-0.okd-2020-10-15-235428
    
    # Fedora CoreOS installation version and stream
    okd_lab_install_fcos_version: '32.20200629.3.0'
    okd_lab_install_fcos_stream: 'stable'

```

Changing any of these settings requires a new setup of the installation environment:

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/01_setup.yml

```

A typical workflow if you already have a cluster installed but want to install a new version:

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/01_setup.yml

ssh root@bastion "cat ~/openshift-install/auth/kubeadmin-password" > ~/okd-lab/.secrets/kubeadmin

ansible-playbook ~/okd-lab/ansible/okd/02_installation.yml

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/03_complete.yml

ansible-playbook ~/okd-lab/ansible/okd/88_bootstrap-destroy.yml

```

You can easily automate this process, if you like!
