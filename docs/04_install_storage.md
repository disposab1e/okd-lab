# Install Storage Cluster

< Prerequisite: [Install OKD4](03_install_okd.md)

* * *

There are two options to install a Rook Ceph Storage Cluster.

## The declarative path (recommended)

Installation with GitOps principles as documented in OKD-LAB-GITOPS (coming soon!).

## The imperative path

Installation with Ansible.

### Install Rook Ceph Storage Cluster

```bash
[lab@lab]

# Install Rook Ceph Storage Cluster
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/storage.yml --tags cluster

```

Wait for rollout complete:

```bash
[lab@lab]

ssh root@bastion "oc get pods -n rook-ceph"

ssh root@bastion "oc get pods -n rook-ceph | grep Completed"

rook-ceph-osd-prepare-worker-0.okd.example.com-ctslv    0/1   Completed   0
rook-ceph-osd-prepare-worker-1.okd.example.com-h52wv    0/1   Completed   0
rook-ceph-osd-prepare-worker-2.okd.example.com-4rqnp    0/1   Completed   0
```

### Setup Rook Ceph Storage Cluster

```bash
[lab@lab]

# Install Rook Ceph Storage Cluster
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/storage.yml --tags setup

```

Let's grab the Ceph Dashboard admin password for later :-)

```bash
[lab@lab]

ssh root@bastion "oc get secret rook-ceph-dashboard-password -o jsonpath=\"{['data']['password']}\" -n rook-ceph | base64 --decode && echo" > ~/okd-lab/.secrets/rook-dashboard

```

### Verify Rook Ceph Storage Cluster

Point your Firefox to: [https://rook-dashboard.apps.okd.example.com](https://rook-dashboard.apps.okd.example.com)

```bash
User: admin

Password: get it from ~/okd-lab/.secrets/rook-dashboard
```

Interact with Ceph Toolbox:

```bash
[root@bastion]

oc -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash


ceph status
ceph osd status
ceph df
rados df
ceph fs status

```

