# Create Public IP
resource "azurerm_public_ip" "bastion" {
  count               = var.create_public_ip ? 1 : 0
  name                = "pubip-bastion-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Generates SSH2 key Pair for Linux VM
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Cteate the local file with SSH private key
resource "local_file" "private_key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "./bastion_private_ssh_key"
  file_permission = "0400"
}

# Create Network Interface
resource "azurerm_network_interface" "bastion" {
  name                = "nic-bastion-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconf-bastion-${var.name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"

    # Conditional assignment: uses PIP ID if it exists, else null
    public_ip_address_id          = try(azurerm_public_ip.bastion[0].id, null)
  }
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "bastion" {
  name                  = "vm-bastion-${var.name}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.bastion.id]
  size                  = var.virtual_machine_size
  tags                  = var.tags
  depends_on            = [azurerm_network_interface.bastion, tls_private_key.rsa]

  os_disk {
    name                 = "os-disk-bastion-${var.name}"
    caching              = "ReadWrite"
    storage_account_type = var.redundancy_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "vm-bastion-${var.name}"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.rsa.public_key_openssh
  }
}
