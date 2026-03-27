esxi_hostname         = "192.168.2.150"
esxi_hostport         = "22"
esxi_hostssl          = "443"
esxi_username         = "root"
esxi_password         = "Welkom01!"

disk_store            = "datastore1"
virtual_network       = "VM Network"
ovf_source            = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"

vm_username           = "iacuser"
ssh_public_key_path   = "/home/s1073133/.ssh/id_ed25519.pub"

webserver_count       = 2
webserver_vcpu        = "1"
webserver_memory      = "2048"

databaseserver_vcpu   = "1"
databaseserver_memory = "2048"