variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_name" {
  type = string
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
  default = "iacuser"
}

variable "ssh_public_key_path" {
  type = string
}