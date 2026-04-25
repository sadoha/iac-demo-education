# Create a resource group using the generated random name
resource "azurerm_resource_group" "example" {
  location  = var.resource_group_location
  name      = "rg-${var.env_prefix}-${var.env_name}"
  tags      = local.all_tags
}

# Create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "vnet-${var.env_prefix}-${var.env_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tags                = local.all_tags
}

# Create a subnet in the Virtual Network
resource "azurerm_subnet" "example" {
  name                  = "subnet-${var.env_prefix}-${var.env_name}"
  resource_group_name   = azurerm_resource_group.example.name
  virtual_network_name  = azurerm_virtual_network.example.name
  address_prefixes      = ["10.0.1.0/24"]
  depends_on            = [azurerm_virtual_network.example]
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "example" {
  name                = "nsg-${var.env_prefix}-${var.env_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tags                = local.all_tags

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
}

# Associate the Network Security Group to the subnet
resource "azurerm_subnet_network_security_group_association" "example_association" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
  depends_on                = [azurerm_subnet.example, azurerm_network_security_group.example]
}

# Create Public IP
resource "azurerm_public_ip" "example" {
  count               = var.instances_count
  name                = "pubip-${var.env_prefix}-${var.env_name}-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.all_tags
}

# Create Network Interface
resource "azurerm_network_interface" "example" {
  count               = var.instances_count
  name                = "nic-${var.env_prefix}-${var.env_name}-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tags                = local.all_tags
  depends_on          = [azurerm_subnet.example, azurerm_public_ip.example]

  ip_configuration {
    name                          = "ipconf-${var.env_prefix}-${var.env_name}-${count.index}"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
  }
}

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

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "example" {
  count                 = var.instances_count
  name                  = "vm-${var.env_prefix}-${var.env_name}-${count.index}"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example[count.index].id]
  size                  = var.virtual_machine_size
  tags                  = local.all_tags
  depends_on            = [azurerm_network_interface.example, tls_private_key.rsa]

  os_disk {
    name                 = "os-disk-${var.env_prefix}-${var.env_name}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = var.redundancy_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "${var.env_prefix}-${var.env_name}-${count.index}"
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
  name                  = "cs-nginx-${var.env_prefix}-${var.env_name}-${count.index}"
  virtual_machine_id    = azurerm_linux_virtual_machine.example[count.index].id
  publisher             = "Microsoft.Azure.Extensions"
  type                  = "CustomScript"
  type_handler_version  = "2.0"
  tags                  = local.all_tags
  depends_on            = [azurerm_linux_virtual_machine.example, time_sleep.example]

  settings = <<SETTINGS
{
 "commandToExecute": "sudo apt-get update && sudo apt-get install nginx -y && echo \"Hello World from $(hostname)\" > /var/www/html/index.html && sudo systemctl restart nginx"
}
SETTINGS
}
