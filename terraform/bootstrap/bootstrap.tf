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

# Don't change anything below please

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "bootstrap" {
  name   = "boostrap.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.disk_size_root_partition
}

resource "libvirt_domain" "bootstrap" {
  name   = "bootstrap"
  memory = local.memory
  vcpu   = local.vcpu

  cpu = {
    mode = "host-passthrough"
  }

  network_interface {
    network_name = "okd"
    mac          = "52:54:00:9f:f8:1c"
  }

  boot_device {
    dev = ["hd", "network"]
  }

  disk {
    volume_id = "${libvirt_volume.bootstrap.id}"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

}
