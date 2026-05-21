terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
}

locals {
  ssh_public_key = trimspace(file(var.ssh_public_key_path))

  azure_cloudinit = templatefile("${path.module}/cloudinit.tftpl", {
    username = var.admin_username
  })
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
}

resource "local_file" "rendered_cloudinit" {
  filename = "${path.module}/rendered-cloudinit.yaml"
  content  = local.azure_cloudinit
}

resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "pip-${var.vm_name_prefix}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-${var.vm_name_prefix}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key
  }

  custom_data = base64encode(local.azure_cloudinit)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "local_file" "vm_ips" {
  filename = "${path.module}/azure_vm_ips.txt"
  content = join("\n", [
    for i in range(var.vm_count) :
    "${azurerm_linux_virtual_machine.vm[i].name} = ${azurerm_public_ip.pip[i].ip_address}"
  ])
}
