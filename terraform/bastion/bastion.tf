locals {

  # the amount of memory in MiB
  # recommended 24GB with all possible services
  memory = "24600"

  # the amount of virtual cpus
  vcpu = 12

}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "bastion" {
  name   = "bastion.qcow2"
  pool   = "default"
  format = "qcow2"
  source = "/tmp/bastion.qcow2"
}

resource "libvirt_domain" "bastion" {
  name      = "bastion"
  memory    = local.memory
  vcpu      = local.vcpu
  autostart = "true"

  cpu = {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = "okd"
    mac            = "52:54:00:7b:14:8c"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.bastion.id}"
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
      host     = "10.0.0.2"
      timeout  = "8m"
    }
    inline = [
      "mkdir /root/.ssh",
    ]
  }

  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "root"
      host     = "10.0.0.2"
    }
    source      = "~/.ssh"
    destination = "/root/"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "root"
      host     = "10.0.0.2"
    }
    inline = [
      "chmod u=rw,go= ~/.ssh/id_rsa ~/.ssh/id_rsa.pub"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook --ssh-extra-args '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' -i '10.0.0.2,' --private-key ~/.ssh/id_rsa -T 300 ~/github/okd-lab/ansible/bastion/terraform.yml"
  }

}
