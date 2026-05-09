variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "virtual_network_name" {
  type    = string
  default = "iac-vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = "iac-subnet"
}

variable "subnet_address_prefixes" {
  type    = list(string)
  default = ["10.10.1.0/24"]
}

variable "network_security_group_name" {
  type    = string
  default = "iac-nsg"
}

variable "vm_count" {
  type    = number
  default = 2
}

variable "vm_name_prefix" {
  type    = string
  default = "azurevm"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2ats_v2"
}

variable "admin_username" {
  type    = string
  default = "iac"
}

variable "ssh_public_key_path" {
  type = string
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "ubuntu-24_04-lts"
}

variable "image_sku" {
  type    = string
  default = "server"
}

variable "image_version" {
  type    = string
  default = "latest"
}