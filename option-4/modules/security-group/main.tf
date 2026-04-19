locals {
  nsg_inbound_rules = { for idx, security_rule in var.nsg_inbound_rules : security_rule.name => {
    idx : idx,
    security_rule : security_rule,
    }
  }
}

# Create Network Security the Group
resource "azurerm_network_security_group" "example" {
  name                = "nsg-${var.security_group_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Create Network Security Group rules
resource "azurerm_network_security_rule" "example_rule" {
  for_each                    = local.nsg_inbound_rules
  name                        = each.key
  priority                    = 100 * (each.value.idx + 1)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = each.value.security_rule.destination_port_protocol
  source_port_range           = "*"
  destination_port_range      = each.value.security_rule.destination_port_range
  source_address_prefix       = each.value.security_rule.source_address_prefix
  destination_address_prefix  = each.value.security_rule.destination_address_prefix
  resource_group_name         = azurerm_network_security_group.example.resource_group_name
  network_security_group_name = azurerm_network_security_group.example.name
  depends_on                  = [azurerm_network_security_group.example]
}

# Associate the Network Security Group to the subnet
resource "azurerm_subnet_network_security_group_association" "example_association" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.example.id
  depends_on                = [azurerm_network_security_group.example]
}
