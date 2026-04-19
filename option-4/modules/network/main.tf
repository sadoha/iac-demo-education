# Create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "vnet-${var.vnet_name}"
  address_space       = var.address_spaces
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Create a subnet in the Virtual Network
resource "azurerm_subnet" "example" {
  count                 = length(var.subnet_names)
  name                  = var.subnet_names[count.index]
  resource_group_name   = azurerm_virtual_network.example.resource_group_name
  virtual_network_name  = azurerm_virtual_network.example.name
  address_prefixes      = [var.subnet_prefixes[count.index]]
  depends_on            = [azurerm_virtual_network.example]
}
