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
  subnet_names        = [
                          "subnet-${var.env_prefix}-${var.env_name}",
                          "subnet-${var.env_prefix}-${var.env_name}-bastion"
                        ]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.10.0/24"]
  tags                = local.all_tags
  location            = module.resource-group.resource_group_location
  resource_group_name = module.resource-group.resource_group_name
}

// Azure Security Group
module "security-group" {
  source              = "../../modules/security-group"
  security_group_name = "${var.env_prefix}-${var.env_name}"
  location            = module.resource-group.resource_group_location
  resource_group_name = module.resource-group.resource_group_name
  subnet_id           = module.network.subnets_id          
  tags                = local.all_tags

  nsg_inbound_rules = [
    {
      name                        = "HTTP"
      destination_port_protocol   = "Tcp"
      destination_port_range      = "80"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
    {
      name                        = "SSH"
      destination_port_protocol   = "Tcp"
      destination_port_range      = "22"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
  ]
}

// Azure NAT Gateway
module "nat-gateway" {
  source                  = "../../modules/nat-gateway"
  name                    = "${var.env_prefix}-${var.env_name}"
  location                = module.resource-group.resource_group_location
  resource_group_name     = module.resource-group.resource_group_name
  subnet_id               = module.network.subnets_id[0]
  tags                    = local.all_tags
}

// Azure Virtual Machine
module "virtual-machine" {
  source                  = "../../modules/virtual-machine"
  name                    = "${var.env_prefix}-${var.env_name}"
  location                = module.resource-group.resource_group_location
  resource_group_name     = module.resource-group.resource_group_name
  subnet_id               = module.network.subnets_id[0]
  instances_count         = var.instances_count
  tags                    = local.all_tags
}

// Azure Load Balancer
module "load-balancer" {
  source                    = "../../modules/load-balancer"
  name                      = "${var.env_prefix}-${var.env_name}"
  location                  = module.resource-group.resource_group_location
  resource_group_name       = module.resource-group.resource_group_name
  network_interface_ids     = module.virtual-machine.network_interface_ids
  network_interface_ip_conf = module.virtual-machine.network_interface_ip_configuration
  instances_count           = module.virtual-machine.instances_count
  tags                      = local.all_tags
}

// Azure Virtual Machine Bastion
module "virtual-machine-bastion" {
  source                  = "../../modules/virtual-machine-bastion"
  name                    = "${var.env_prefix}-${var.env_name}"
  location                = module.resource-group.resource_group_location
  resource_group_name     = module.resource-group.resource_group_name
  subnet_id               = module.network.subnets_id[1]
  tags                    = local.all_tags
}
