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

# Don't change anything below please

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "worker-0" {
  name   = "worker-0.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.disk_size_root_partition
}

resource "libvirt_volume" "worker-0-raw" {
  name   = "worker-0-raw.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.disk_size_storage_partition
}

resource "libvirt_domain" "worker-0" {
  name   = "worker-0"
  memory = local.memory
  vcpu   = local.vcpu

  network_interface {
    network_name = "okd"
    mac          = "52:54:00:bb:dd:78"
  }

  boot_device {
    dev = ["hd", "network"]
  }

  disk {
    volume_id = "${libvirt_volume.worker-0.id}"
  }

  disk {
    volume_id = "${libvirt_volume.worker-0-raw.id}"
  }

  graphics {
    listen_type = "none"
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

resource "libvirt_volume" "worker-1" {
  name   = "worker-1.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.disk_size_root_partition
}

resource "libvirt_volume" "worker-1-raw" {
  name   = "worker-1-raw.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.disk_size_storage_partition
}

resource "libvirt_domain" "worker-1" {
  name   = "worker-1"
  memory = local.memory
  vcpu   = local.vcpu

  network_interface {
    network_name = "okd"
    mac          = "52:54:00:f7:84:c9"
  }

  boot_device {
    dev = ["hd", "network"]
  }

  disk {
    volume_id = "${libvirt_volume.worker-1.id}"
  }

  disk {
    volume_id = "${libvirt_volume.worker-1-raw.id}"
  }

  graphics {
    listen_type = "none"
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

resource "libvirt_volume" "worker-2" {
  name   = "worker-2.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.disk_size_root_partition
}

resource "libvirt_volume" "worker-2-raw" {
  name   = "worker-2-raw.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.disk_size_storage_partition
}

resource "libvirt_domain" "worker-2" {
  name   = "worker-2"
  memory = local.memory
  vcpu   = local.vcpu

  network_interface {
    network_name = "okd"
    mac          = "52:54:00:19:6b:b4"
  }

  boot_device {
    dev = ["hd", "network"]
  }

  disk {
    volume_id = "${libvirt_volume.worker-2.id}"
  }

  disk {
    volume_id = "${libvirt_volume.worker-2-raw.id}"
  }

  graphics {
    listen_type = "none"
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
