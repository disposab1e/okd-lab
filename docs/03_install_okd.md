# Install OKD4

< Prerequisite: [Provision infrastructure](02_provision_infrastructure.md)

* * *

Let's start with the fun part!

- Quay Tokens
- Red Hat OpenShift operators catalog (optional)
- Installation version
- Installation environment
- Verify installation environment
- Installation
- Complete installation
- Verify installation
- Day-1 Configurations
- Destroy Cluster

## Quay Tokens

A Bearer and Application Token is required to gain access to Quay. Let's [create one](03_quay_token.md)!

## Red Hat OpenShift operators catalog (optional)

This step is only required if you want to install operators from Red Hat's OpenShift Operators Catalog. Go to your [Red Hat OpenShift cluster manager portal](https://cloud.redhat.com/openshift/install/azure/aro-provisioned) and select `Copy pull secret`. 
Add your secret to `[lab@lab ~/okd-lab/.secrets/pull-secret.json]` and remove the `cloud.openshift.com` entry if you don't want to send telemetry data about your server to Red Hat. Your secret will look like the follwing:

```json
{
    "auths": {
        "quay.okd.example.com": {
        "auth": "JGFwcDpHUDU3OVVNTVVQTFpJT0M0R1o4RTJPRzlYTE1SQUQ1RUQ5TUVTWFdJQ1BZWU1QNkg3R0w4RklQQlJTNjFCVkMxWkQ0TkdGM1A0RVlGNEJBU1k0MkhSWUxaWktBUkdaT0taTTJHWEQ5QldRSlRNRE5FQzcxS0ZRSFc=",
        "email": "admin@example.com"
        },
        "quay.io": {
            "auth": "bbbbbb",
            "email": "your@email"
        },
        "registry.connect.redhat.com": {
            "auth": "cccccc",
            "email": "your@email"
        },
        "registry.redhat.io": {
            "auth": "dddddd",
            "email": "your@email"
        }
    }
}
```

## Installation version

It's time to decide which version to install. The default settings should be kept during the first installation.

```yaml

    # Unique name of this installation
    okd_lab_install_okd_name: '4-7-0-0-okd-2021-04-24-103438'

    # OKD installation version
    okd_lab_install_okd_version: 4.7.0-0.okd-2021-04-24-103438

    # Fedora CoreOS installation version and stream
    okd_lab_install_fcos_stream: 'stable' 
    okd_lab_install_fcos_version: '33.20210328.3.0'

```

Of course there is also a possibility to [install other versions](03_installation_version.md).

## Tested versions

| OKD  | Fedora CoreOS |
|---|---|
| 4.7.0-0.okd-2021-03-07-090821  | stable/33.20210201.3.0  |
| 4.7.0-0.okd-2021-04-24-103438  | stable/33.20210328.3.0  |


## Installation environment

Setting up an installation environment is the first step during OKD installations. 

The simplified workflow to prepare an installation environment is as follows:

- Setup installation environment
- Mirror Fedora CoreOS and OKD Registry Mirror
- Prepare installer to use Registry Mirror

```bash
[lab@lab]

# Setup OKD installation environment
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags env-setup

# Mirror Fedorea CoreOS, PXE's and Registry Mirror
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/mirror.yml --tags mirror

# Setup OKD Installer to use Registry Mirror
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/setup.yml --tags installer-setup


# Let's grab the kubeadmin password for later
ssh root@bastion "cat ~/installer/auth/kubeadmin-password" > ~/okd-lab/.secrets/kubeadmin

```

## Verify installation environment

 * Point your Firefox to [https://quay.okd.example.com/repository](https://quay.okd.example.com/repository). Login as user `admin` with password `admin` and check that you have a repository starting with `admin_okd_registry`.

* Point your Firefox to [http://mirror.okd.example.com](http://mirror.okd.example.com) and check you find a `ignition` and `fcos` directory.

## Installation

You can provision `bootstrap`, `master` and `worker` nodes all at the same time and than wait for cluster to complete. The strength is to be found in serenity :-)

```bash
[lab@lab]
#
# Apply (provision) Cluster with Terraform
ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags apply

```

Please note! Under rare circumstances some `bootstrap`, `master` and `worker` nodes may not boot immediately. If this happens, remove the `cluster` and start the installlation again. Help welcome to find a fix!

```bash
[lab@lab]

# Destroy (unprovision) Cluster with Terraform
ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags destroy

# Apply (provision) Cluster with Terraform
ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags apply

```

## Complete installation

 - Waiting bootstrap to complete
 - Waiting installation to complete
 - Approve certificate signing requests (csr) and join workers
 - Apply NTP (chrony) configuration

```bash
[lab@lab]

# Complete OKD installation
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/okd.yml --tags complete

```

### Follow HAProxy stats (optional)

 * Point your Firefox to [https://lb.okd.example.com:9000](https://lb.okd.example.com:9000) and watch the stats.

### Follow cluster operators and nodes (optional)

```bash

[root@bastion]

watch -n2 oc get clusteroperators

oc get nodes --watch=true

```

### Remove `bootstrap` node (optional)

After the `Waiting bootstrap to complete` task has finished it's save to remove the `bootstrap` (e.g. in a second terminal).

```bash
[lab@lab]

# Destroy Bootstrap with Terraform
ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags bootstrap-destroy

```

## Verify installation

### Verify nodes

It will take some time until all nodes are in `Ready` state but you can already interact with your new cluster. You will recognize that `master` and `worker` nodes will switch to `NotReady,SchedulingDisabled` state. This is intentional cause NTP time synchronization will be applied to all nodes after initial installation. The strength again is to be found in serenity.

```bash
[lab@lab]

ssh root@bastion "oc get nodes"

[root@bastion ~]# oc get nodes
NAME                       STATUS      ROLES                 AGE     VERSION
master-0.okd.example.com   Ready       master,worker         28m     v1.20.0+5fbfd19-1046
master-1.okd.example.com   Ready       master,worker         28m     v1.20.0+5fbfd19-1046
master-2.okd.example.com   Ready       master,worker         28m     v1.20.0+5fbfd19-1046
worker-0.okd.example.com   Ready       worker                3m42s   v1.20.0+5fbfd19-1046
worker-1.okd.example.com   Ready       worker                3m37s   v1.20.0+5fbfd19-1046
worker-2.okd.example.com   Ready       worker                3m39s   v1.20.0+5fbfd19-1046

```

## Day-1 Configurations

### Basic configuration

 - Manage internal OKD Registry and add some temporary storage
 - Label masters as infra nodes
 - Stick routers to master/infra nodes
 - Enable Image Pruner
 - Disable Samples Operator
 - Enable LDAP authorization provider
 - Create admin user within the cluster-admin role
 - Trusted custom Certificate Authority and SSL certificates for Web console, Router and API

```bash
[lab@lab]

# Day-1 OKD configurations
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/okd.yml --tags config

```

Now inspect your cluster operators. 

```bash

[root@bastion]

watch -n2 oc get clusteroperators

```

The change of the SSL certificates for the API will bring up an error: `Unable to connect to the server: x509: certificate signed by unknown authority` after a few minutes. Wait until this error stays forever in your terminal! This will take some time!

After that, point your Firefox to OKD Web Console at [https://console-openshift-console.apps.okd.example.com](https://console-openshift-console.apps.okd.example.com) and login with user `admin` and password `admin`.

Click on your `Admin` user and choose `Copy login command`, than choose `Display Token`. Copy `Your API token is` to `XXXXXXXXXX` in the following command and execute it. 

```bash

[root@bastion]

oc login --token=XXXXXXXXXX --server=https://api.okd.example.com:6443 --certificate-authority=/etc/ca.crt

```

Now you can interact with the API again. Just wait a few more minutes until all cluster operators are in `Available` state and no longer `Processing` or `Degraded`.

```bash

[root@bastion]

watch -n2 oc get clusteroperators

NAME                                       VERSION                         AVAILABLE   PROGRESSING   DEGRADED   SINCE
authentication                             4.7.0-0.okd-2021-04-24-103438   True        False         False      15m
baremetal                                  4.7.0-0.okd-2021-04-24-103438   True        False         False      57m
cloud-credential                           4.7.0-0.okd-2021-04-24-103438   True        False         False      58m
cluster-autoscaler                         4.7.0-0.okd-2021-04-24-103438   True        False         False      55m
config-operator                            4.7.0-0.okd-2021-04-24-103438   True        False         False      57m
console                                    4.7.0-0.okd-2021-04-24-103438   True        False         False      16m
csi-snapshot-controller                    4.7.0-0.okd-2021-04-24-103438   True        False         False      8m56s
dns                                        4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
etcd                                       4.7.0-0.okd-2021-04-24-103438   True        False         False      55m
image-registry                             4.7.0-0.okd-2021-04-24-103438   True        False         False      18m
ingress                                    4.7.0-0.okd-2021-04-24-103438   True        False         False      51m
insights                                   4.7.0-0.okd-2021-04-24-103438   True        False         False      50m
kube-apiserver                             4.7.0-0.okd-2021-04-24-103438   True        False         False      54m
kube-controller-manager                    4.7.0-0.okd-2021-04-24-103438   True        False         False      54m
kube-scheduler                             4.7.0-0.okd-2021-04-24-103438   True        False         False      54m
kube-storage-version-migrator              4.7.0-0.okd-2021-04-24-103438   True        False         False      17m
machine-api                                4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
machine-approver                           4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
machine-config                             4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
marketplace                                4.7.0-0.okd-2021-04-24-103438   True        False         False      9m22s
monitoring                                 4.7.0-0.okd-2021-04-24-103438   True        False         False      29m
network                                    4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
node-tuning                                4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
openshift-apiserver                        4.7.0-0.okd-2021-04-24-103438   True        False         False      17m
openshift-controller-manager               4.7.0-0.okd-2021-04-24-103438   True        False         False      19m
openshift-samples                          4.7.0-0.okd-2021-04-24-103438   True        False         False      21m
operator-lifecycle-manager                 4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
operator-lifecycle-manager-catalog         4.7.0-0.okd-2021-04-24-103438   True        False         False      56m
operator-lifecycle-manager-packageserver   4.7.0-0.okd-2021-04-24-103438   True        False         False      9m49s
service-ca                                 4.7.0-0.okd-2021-04-24-103438   True        False         False      57m
storage                                    4.7.0-0.okd-2021-04-24-103438   True        False         False      57m
```

### DockerHub rate limit (optional)

It's possible that you reach Docker's rate limit for anonymous access when you move forward. This [blog article](https://developers.redhat.com/blog/2021/02/18/how-to-work-around-dockers-new-download-rate-limit-on-red-hat-openshift/) describes how to fix it for OKD. 

For your convenience:

```yaml

[lab@lab ~/okd-lab/.secrets/dockerhub.json]

{
    "username": "DockerHub Username",
    "password": "DockerHub Password/Token",
    "email": "DockerHub Email",
    "server": "docker.io"
}

[lab@lab]

# Create docker.io pull secret to enahance your limits
ansible-playbook -i bastion, ~/okd-lab/ansible/okd/dockerhub.yml

```
Plase Note: This will restart all `master` and `worker` nodes again! So please stay tuned.

## Destroy Cluster

After so much work it's always hard. But prepare to do so. You will see, a new installation does not take to long!

```bash
[lab@lab]

ansible-playbook ~/okd-lab/ansible/okd/cluster.yml --tags destroy

```

* * *

Next > [Install Storage Cluster](04_install_storage.md)
