# Create Public IP
resource "azurerm_public_ip" "example" {
  name                = "pubip-lb-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create Public Load Balancer
resource "azurerm_lb" "example" {
  name                = "lb-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
  depends_on          = [azurerm_public_ip.example]

  frontend_ip_configuration {
    name                 = azurerm_public_ip.example.name
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

# Create Backend Address Pool for the Load Balancer
resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "pool-${var.name}"
  depends_on      = [azurerm_lb.example]
}

# Associate Network Interface to the Backend Pool of the Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count                   = var.instances_count
  network_interface_id    = var.network_interface_ids[count.index]
  ip_configuration_name   = var.network_interface_ip_conf[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  depends_on              = [azurerm_lb.example]
}

# Create Load Balancer Health Probe
resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "probe-${var.name}"
  port            = 80
  depends_on      = [azurerm_lb.example]
}

# Create Load Balancer Rule
# This rule will forward traffic from the frontend IP configuration to the backend address pool
# on port 80 using TCP protocol. It also disables outbound SNAT for the backend pool.
# The probe is used to check the health of the backend instances.
resource "azurerm_lb_rule" "example_rule" {
  loadbalancer_id                 = azurerm_lb.example.id
  name                            = "rule-${var.name}"
  protocol                        = "Tcp"
  frontend_port                   = 80
  backend_port                    = 80
  disable_outbound_snat           = true
  frontend_ip_configuration_name  = azurerm_public_ip.example.name
  probe_id                        = azurerm_lb_probe.example.id
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.example.id]
  depends_on                      = [azurerm_lb.example]
}

resource "azurerm_lb_outbound_rule" "example_rule_outbound" {
  name                    = "rule-outbound-${var.name}"
  loadbalancer_id         = azurerm_lb.example.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  depends_on              = [azurerm_lb.example]

  frontend_ip_configuration {
    name = azurerm_public_ip.example.name
  }
}
