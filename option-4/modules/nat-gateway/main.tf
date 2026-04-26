# Create Public IP
resource "azurerm_public_ip" "nat" {
  name                = "pubip-nat-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create NAT Gateway
resource "azurerm_nat_gateway" "nat" {
  name                = "nat-gw-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

# Association the public ip to the nat gateway
resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id        = azurerm_nat_gateway.nat.id
  public_ip_address_id  = azurerm_public_ip.nat.id
  depends_on            = [azurerm_nat_gateway.nat, azurerm_public_ip.nat]
}

# Association the subnet to the nat gateway
resource "azurerm_subnet_nat_gateway_association" "nat" {
  subnet_id       = var.subnet_id
  nat_gateway_id  = azurerm_nat_gateway.nat.id
  depends_on      = [azurerm_nat_gateway.nat]
}
