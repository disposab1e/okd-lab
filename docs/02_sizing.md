# Lab sizing

< [Provision infrastructure](02_provision_infrastructure.md)

* * *

## VM customizations

It depends on the specs of your physical machine if you have to tweak some settings.

Below are the default settings for this example machine:

- AMD Ryzen 9 3900 12-Core (24 vCPU)
- 128 GB DDR4 ECC
- 2 x 1,92 TB NVMe SSD

Change it to your needs. Whenever possible, leave everything as it is.

### Bastion: `bastion`

`[ lab@lab ~/okd-lab/packer/bastion/bastion.json ]`

If you need to modify the disk space of your bastion host, than it's best to define it before you build the image with packer. However it's also possible to expand the disk size of an existing VM with the usual KVM tooling. See also [Service customizations](#Service%20customizations).

```JSON

  "variables": {

    "okd_lab_disk_size": "500G",

    .....

  }
```

`[ lab@lab ~/okd-lab/terraform/bastion/bastion.tf ]`

```YAML

locals {

  # the amount of memory in MiB
  # recommended 24GB with all possible services
  memory = "24600"

  # the amount of virtual cpus
  vcpu = 12

}
```

### Load Balancer: `lb`

`[ lab@lab ~/okd-lab/terraform/lb/lb.tf ]`

```YAML

locals {

  # the amount of memory in MiB
  # recommended 2GB
  memory = "2048"

  # the amount of virtual cpus
  vcpu = 12

}
```

### Bootstrap: `bootstrap`

`[ lab@lab ~/okd-lab/terraform/bootstrap/bootstrap.tf ]`

```YAML

locals {

  # the amount of memory in MiB
  # redhat minimum: 8GB
  memory = "16384"

  # the amount of virtual cpus
  # redhat minimum: 4 vCPU
  vcpu = 12

  # size of the root partition volume in bytes
  # redhat minimum: 120GB
  disk_size_root_partition = "161061273600"

}
```

### Master: `master-(0-2)`

`[ lab@lab ~/okd-lab/terraform/master/master.tf ]`

Please note! These settings apply to all masters!

```YAML

locals {

  # the amount of memory in MiB
  # redhat minimum: 16GB
  memory = "16384"

  # the amount of virtual cpus
  # redhat minimum: 4 vCPU
  vcpu = 12

  # size of the root partition volume in bytes
  # redhat minimum: 120GB
  disk_size_root_partition = "214748364800"

  # partition for ceph storage cluster in bytes
  disk_size_storage_partition = "429496729600"

}
```

### Worker: `worker-(0-2)`

`[ lab@lab ~/okd-lab/terraform/worker/worker.tf ]`

Please note! These settings apply to all workers!

```YAML

locals {

  # the amount of memory in MiB
  # redhat minimum: 8GB
  memory = "16384"

  # the amount of virtual cpus
  # redhat minimum: 2 vCPU
  vcpu = 12

  # size of the root partition volume in bytes
  # redhat minimum: 120GB
  disk_size_root_partition = "214748364800"

  # partition for ceph storage cluster in bytes
  disk_size_storage_partition = "429496729600"

}
```

## Service customizations

To save some disk space or memory on the `bastion` host you can disable optional services. Just comment out what you don't need.

`[ lab@lab ~/okd-lab/ansible/bastion/terraform.yml ]`

```YAML

---
- hosts: 10.0.0.2
  gather_facts: no
  remote_user: root
  roles:
# required
    - ipxe
    - jq
    - docker
    - quay
# optional
    - gitlab
    - portainer
    - keycloak
    - artifactory

}
```

Please note! You have to provision your `bastion` host again. A typical workflow if you disbale/enable some of these services:

```bash
[lab@lab]

cd ~/okd-lab/terraform/bastion
terraform destroy -auto-approve
terraform apply -auto-approve
```
