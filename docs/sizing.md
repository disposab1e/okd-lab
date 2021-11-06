# Lab sizing

< [Provision infrastructure](02_provision_infrastructure.md)

* * *

## VM customizations

It depends on the specs of your physical machine whether you need to adjust some settings.

Below are the default settings for this example machine:

- AMD Ryzen 9 3900 12-Core (24 vCPU)
- 128 GB DDR4 ECC
- 2 x 1,92 TB NVMe SSD

Change it to your needs. Whenever possible, leave everything as it is for your first installation.

### Bastion: `bastion`

`[ lab@lab ~/github/okd-lab/packer/bastion/bastion.json ]`

If you need to modify the disk space of your bastion host, than it's best to define it before you build the image with packer. However it's also possible to expand the disk size of an existing VM with the usual KVM tooling.

```JSON

  "variables": {

    "okd_lab_disk_size": "1000G",

    .....

  }
```

`[ lab@lab ~/github/okd-lab/terraform/bastion/bastion.tf ]`

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

`[ lab@lab ~/github/okd-lab/terraform/lb/lb.tf ]`

```YAML

locals {

  # the amount of memory in MiB
  # recommended 2GB
  memory = "2048"

  # the amount of virtual cpus
  vcpu = 4

}
```

### Bootstrap: `bootstrap`

`[ lab@lab ~/github/okd-lab/terraform/bootstrap/bootstrap.tf ]`

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

`[ lab@lab ~/github/okd-lab/terraform/master/master.tf ]`

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

  # partition for ceph storage cluster in bytes (spare drives not used now)
  disk_size_storage_partition = "429496729600"

}
```

### Worker: `worker-(0-2)`

`[ lab@lab ~/github/okd-lab/terraform/worker/worker.tf ]`

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
  disk_size_storage_partition = "858993459200"

}
```
