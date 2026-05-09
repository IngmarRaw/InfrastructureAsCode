subscription_id       = "c064671c-8f74-4fec-b088-b53c568245eb"
resource_group_name   = "rg-iac-azure"
location              = "westeurope"

virtual_network_name       = "iac-vnet"
subnet_name                = "iac-subnet"
network_security_group_name = "iac-nsg"

vm_count            = 2
vm_name_prefix      = "azurevm"
vm_size             = "Standard_B2ats_v2"
admin_username      = "iac"
ssh_public_key_path = "/home/s1073133/.ssh/id_ed25519.pub"