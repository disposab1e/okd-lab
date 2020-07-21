locals {

  # the amount of memory in MiB
  # recommended 2GB
  memory = "2048"

  # the amount of virtual cpus
  vcpu = 12

}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "lb" {
  name   = "lb.qcow2"
  pool   = "default"
  format = "qcow2"
  source = "/tmp/lb.qcow2"
}

resource "libvirt_domain" "lb" {
  name      = "lb"
  memory    = local.memory
  vcpu      = local.vcpu
  autostart = "true"

  cpu = {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = "okd"
    mac            = "52:54:00:48:b5:f9"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.lb.id}"
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

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "root"
      host     = "10.0.0.99"
      timeout  = "8m"
    }
    inline = ["mkdir -p /root/.ssh"]
  }

  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "root"
      host     = "10.0.0.99"
      timeout  = "8m"
    }
    source      = "~/okd-lab/.ssh/authorized_keys"
    destination = "/root/.ssh/authorized_keys"
  }
}
