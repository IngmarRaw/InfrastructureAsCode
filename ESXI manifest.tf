terraform {
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}

provider "esxi" {
  esxi_hostname = "192.168.2.150"
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = "Welkom01!"
}

locals {
  ssh_public_key = trimspace(file("~/.ssh/id_ed25519.pub"))
}

resource "esxi_guest" "webserver" {
  count      = 2
  guest_name = "webserver-${count.index + 1}"
  disk_store = "datastore1"

  memsize   = "2048"
  numvcpus  = "1"
  power     = "on"

  ovf_source = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"

  network_interfaces {
    virtual_network = "VM Network"
  }

  guestinfo = {
    "userdata" = base64gzip(<<-EOT
      #cloud-config
      users:
        - name: ubuntu
          ssh_authorized_keys:
            - ${local.ssh_public_key}
      EOT
    )
    "userdata.encoding" = "gzip+base64"

    "metadata" = base64gzip(jsonencode({
      "local-hostname" = "webserver-${count.index + 1}"
      "instance-id"    = "webserver-${count.index + 1}"
    }))
    "metadata.encoding" = "gzip+base64"
  }
}

resource "esxi_guest" "databaseserver" {
  guest_name = "databaseserver"
  disk_store = "datastore1"

  memsize   = "2048"
  numvcpus  = "1"
  power     = "on"

  ovf_source = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"

  network_interfaces {
    virtual_network = "VM Network"
  }

  guestinfo = {
    "userdata" = base64gzip(<<-EOT
      #cloud-config
      users:
        - name: ubuntu
          ssh_authorized_keys:
            - ${local.ssh_public_key}
      EOT
    )
    "userdata.encoding" = "gzip+base64"

    "metadata" = base64gzip(jsonencode({
      "local-hostname" = "databaseserver"
      "instance-id"    = "databaseserver"
    }))
    "metadata.encoding" = "gzip+base64"
  }
}