# Install OKD4

< Prerequisite: [Provision infrastructure](02_provision_infrastructure.md)

* * *

Let's start with the fun part!

- Secrets
- Installation version
- Installation environment
- Installation
- Complete
- Verify installation
- OKD Web Console
- Cluster Storage
- Registry Storage
- Destroy Cluster

## Secrets

### Red Hat pull secret

A [pull secret](03_pull_secret.md) is required to gain access to the Red Hat Container Registry. After you have saved your Red Hat pull secret, merge it with the existing Quay pull secret.

```bash
[lab@lab]

ansible-playbook ~/okd-lab/ansible/okd/00_secrets.yml

```

### Quay token

A Bearer Token is required to gain access to Quay's API. Let's [create one](03_quay_token.md)!

## Installation version

It's time to decide which version to install. The default settings should be kept during the first installation.

```yaml

    # Unique name of installation
    okd_lab_install_name: '4-4-0-okd-2020-05-23-beta-5'

    # OKD installation version
    okd_lab_install_okd_version: 4.4.0-0.okd-2020-05-23-055148-beta5

    # Fedora CoreOS installation version and stream
    okd_lab_install_fcos_version: '31.20200517.3.0'
    okd_lab_install_fcos_stream: 'stable'

```

Of course there is a possibility to [install other versions](03_installation_version.md).

## Installation environment

Typically, the environment in which a cluster is installed will not have access to the Internet. All artifacts that are needed during the installation must therefore be mirrored on the `bastion` host. This includes all Container Images and Fedora CoreOS.

The simplified workflow to prepare an air-gap installation environment is as follows:

- Mirror Fedora CoreOS
- Mirror Container Registry
- Prepare installer for air-gap installation
- Prepare and publish ignition and PXE files

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/01_setup.yml

```

Let's grab the kubeadmin password for later :-)

```bash
[lab@lab]

ssh root@bastion "cat ~/openshift-install/auth/kubeadmin-password" > ~/okd-lab/.secrets/kubeadmin

```

## Installation

You can provision bootstrap, master and worker nodes all at the same time and than wait for cluster to complete. The strenght is to be found in serenity :-)

```bash
[lab@lab]

ansible-playbook ~/okd-lab/ansible/okd/02_installation.yml

```

Please note! Under rare circumstances the `bootstrap` node may not boot immediately. If this happens, remove the `bootstrap` and start the installlation again. Help welcome to find a fix!

```bash
[lab@lab]

ansible-playbook ~/okd-lab/ansible/okd/88_bootstrap-destroy.yml
ansible-playbook ~/okd-lab/ansible/okd/88_bootstrap-apply.yml

```

When you experience the same with `master` and/or `worker` nodes fix it with:

```bash
[lab@lab]

cd ~/okd-lab/terraform/master
terraform destroy -auto-approve
terraform apply -auto-approve

cd ~/okd-lab/terraform/worker
terraform destroy -auto-approve
terraform apply -auto-approve

```

## Complete

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/03_complete.yml

```

### Follow HAProxy stats (optional)

Point your Firefox to [http://lb.okd.example.com:9000](http://lb.okd.example.com:9000) and watch the stats.

### Remove `bootstrap` node

After the `Waiting bootstrap to complete` task has finished it's save to remove the `bootstrap` (e.g. in a second terminal).

```bash
[lab@lab]

ansible-playbook ~/okd-lab/ansible/okd/88_bootstrap-destroy.yml

```

## Verify installation

### Verify nodes

It will take some time to apply the infrastructure configuration and you will see all nodes restarting. The strenght again is to be found in serenity :-) But you can already interact with your new cluster, be prepared that during restart of nodes some temporary erros can occur. Be patient all will be fine after a while.

```bash
[lab@lab]

ssh root@bastion "oc get nodes"

NAME                       STATUS   ROLES           AGE     VERSION
master-0.okd.example.com   Ready,SchedulingDisabled   infra,master   22m     v1.17.1
master-1.okd.example.com   Ready                      infra,master   22m     v1.17.1
master-2.okd.example.com   Ready                      infra,master   22m     v1.17.1
worker-0.okd.example.com   Ready                      worker         2m37s   v1.17.1
worker-1.okd.example.com   Ready                      worker         2m37s   v1.17.1
worker-2.okd.example.com   Ready                      worker         2m35s   v1.17.1

```

### Verify cluster operators

```bash

[root@bastion]

watch -n2 oc get clusteroperators

```

### Verify time synchronisation

```bash
[lab@lab]

ssh core@master-0 "cat /etc/chrony.conf"
ssh core@master-0 "chronyc sources"

```

## OKD Web Console

Point your Firefox to OKD Web Console at [https://console-openshift-console.apps.okd.example.com](https://console-openshift-console.apps.okd.example.com) and login with `kube:admin`.

```bash
User: kubeadmin

Password: get it from ~/okd-lab/.secrets/kubeadmin
```

## Cluster Storage

Especially the internal registry and of course your apps need some persistent storage. Let's do it.

### Rook Operator

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/10_rook-operator.yml

```

Wait for rollout complete:

```bash
[lab@lab]

ssh root@bastion "oc rollout status -w deployment/rook-ceph-operator -n rook-ceph"

```

### Rook Ceph Storage Cluster

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/11_rook-cluster.yml

```

Wait for rollout complete:

```bash
[lab@lab]

ssh root@bastion "oc get pods -n rook-ceph | grep Completed"

rook-ceph-osd-prepare-worker-0.okd.example.com-5w456              0/1     Completed   0          2m35s
rook-ceph-osd-prepare-worker-1.okd.example.com-v5l7z              0/1     Completed   0          2m35s
rook-ceph-osd-prepare-worker-2.okd.example.com-nmd42              0/1     Completed   0          2m35s
```

### Ceph Block Storage

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/12_rook-ceph-block.yml

ssh root@bastion "oc get cephblockpool -n rook-ceph"
ssh root@bastion "oc get sc -n rook-ceph"

```

### Ceph File Storage

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/13_rook-ceph-file.yml

ssh root@bastion "oc get cephfilesystem -n rook-ceph"
ssh root@bastion "oc get sc -n rook-ceph"

```

### Ceph Dashboard

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/14_rook-dashboard.yml

```

Let's grab the admin password for later :-)

```bash
[lab@lab]

ssh root@bastion "oc get secret rook-ceph-dashboard-password -o jsonpath=\"{['data']['password']}\" -n rook-ceph | base64 --decode && echo" > ~/okd-lab/.secrets/rook-dashboard

```

Point your Firefox to: [https://rook-dashboard.apps.okd.example.com](https://rook-dashboard.apps.okd.example.com)

```bash
User: admin

Password: get it from ~/okd-lab/.secrets/rook-dashboard
```

### Ceph Toolbox

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/15_rook-toolbox.yml

```

Interact with:

```bash
[root@bastion]

oc -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash


ceph status
ceph osd status
ceph df
rados df
ceph fs status

```

## Registry Storage

Add Ceph Block storage to internal registry.

```bash
[lab@lab]

ansible-playbook -i bastion, ~/okd-lab/ansible/okd/20_registry.yml

```

## Destroy Cluster

After so much work it's always hard. But prepare to do so. You will see, a new installation does not take to long!

```bash
[lab@lab]

ansible-playbook ~/okd-lab/ansible/okd/99_destroy-cluster.yml

```

* * *

The end of the first installation and [the beginning of a new one](03_installation_version.md) :-)
