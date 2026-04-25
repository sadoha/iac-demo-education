# Generates SSH2 key Pair for Linux VM
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Cteate the local file with SSH private key
resource "local_file" "private_key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "./private_ssh_key"
  file_permission = "0400"
}

# Create Network Interface
resource "azurerm_network_interface" "example" {
  count               = var.instances_count
  name                = "nic-${var.name}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconf-${var.name}-${count.index}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "example" {
  count                 = var.instances_count
  name                  = "vm-${var.name}-${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.example[count.index].id]
  size                  = var.virtual_machine_size
  tags                  = var.tags
  depends_on            = [azurerm_network_interface.example, tls_private_key.rsa]

  os_disk {
    name                 = "os-disk-${var.name}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = var.redundancy_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "vm-${var.name}-${count.index}"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.rsa.public_key_openssh
  }
}

# Delay before running the next step
resource "time_sleep" "example" {
  depends_on = [azurerm_linux_virtual_machine.example]
  create_duration = "90s"
}

# Enable virtual machine extension and install Nginx
resource "azurerm_virtual_machine_extension" "example" {
  count                 = var.instances_count
  name                  = "cs-nginx-${var.name}-${count.index}"
  virtual_machine_id    = azurerm_linux_virtual_machine.example[count.index].id
  publisher             = "Microsoft.Azure.Extensions"
  type                  = "CustomScript"
  type_handler_version  = "2.0"
  tags                  = var.tags
  depends_on            = [azurerm_linux_virtual_machine.example, time_sleep.example]

  settings = <<SETTINGS
{
 "commandToExecute": "sudo apt-get update && sudo apt-get install nginx -y && echo \"Hello World from $(hostname)\" > /var/www/html/index.html && sudo systemctl restart nginx"
}
SETTINGS
}
