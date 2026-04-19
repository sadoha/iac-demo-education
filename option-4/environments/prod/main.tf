// Azure Resource Group
module "resource-group" {
  source    = "../../modules/resource-group"
  location  = var.resource_group_location
  name      = "${var.env_prefix}-${var.env_name}"
  tags      = local.all_tags
}

// Azure Network
module "network" {
  source              = "../../modules/network"
  vnet_name           = "${var.env_prefix}-${var.env_name}"
  subnet_names        = ["subnet-${var.env_prefix}-${var.env_name}"]
  subnet_prefixes     = ["10.0.100.0/24"]
  tags                = local.all_tags
  location            = module.resource-group.resource_group_location
  resource_group_name = module.resource-group.resource_group_name
}

// Azure Security Group
module "security-group" {
  source              = "../../modules/security-group"
  security_group_name = "${var.env_prefix}-${var.env_name}"
  tags                = local.all_tags
  location            = module.resource-group.resource_group_location
  resource_group_name = module.resource-group.resource_group_name
  subnet_id           = module.network.subnets_id[0]          

  nsg_inbound_rules = [
    {
      name                        = "HTTP"
      destination_port_protocol   = "Tcp"
      destination_port_range      = "80"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
  ]
}

// Azure Virtual Machine
module "virtual-machine" {
  source                  = "../../modules/virtual-machine"
  name                    = "${var.env_prefix}-${var.env_name}"
  tags                    = local.all_tags
  location                = module.resource-group.resource_group_location
  resource_group_name     = module.resource-group.resource_group_name
  subnet_id               = module.network.subnets_id[0]
  instances_count         = var.instances_count
}

// Azure Load Balancer
module "load-balancer" {
  source                    = "../../modules/load-balancer"
  name                      = "${var.env_prefix}-${var.env_name}"
  tags                      = local.all_tags
  location                  = module.resource-group.resource_group_location
  resource_group_name       = module.resource-group.resource_group_name
  network_interface_ids     = module.virtual-machine.network_interface_ids
  network_interface_ip_conf = module.virtual-machine.network_interface_ip_configuration
  instances_count           = var.instances_count
}
