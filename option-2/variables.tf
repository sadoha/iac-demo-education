variable "resource_group_location" {
  type          = string
  default       = "eastus"
  description   = "Location of the resource group"
}

variable "env_name" {
  type          = string
  default       = "test-01"
  description   = "The name of the environment"
}

variable "env_prefix" {
  type          = string
  default       = "demo"
  description   = "The environment prefix"
}

variable "instances_count" {
  type          = number
  default       = 2
  description   = "The number of Virtual Machines required"
}

variable "username" {
  type          = string
  description   = "The username for the local account that will be created on the new VM"
  default       = "azureadmin"
}

variable "virtual_machine_size" {
  type        = string
  default     = "Standard_B1ls"
  description = "Size or SKU of the Virtual Machine"
}

variable "redundancy_type" {
  type        = string
  default     = "Standard_LRS"
  description = "Storage redundancy type of the OS disk"
}

variable "extra_tags" {
  type    = map(string)
  default = {}
  description = "Any extra tags that should be present on the environment"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Any tags that should be present on the environment"
}

locals {
  # Construct the map using variables
  common_tags = {
    Environment = var.env_name
    Project     = var.env_prefix
    ManagedBy   = "Terraform"
    Reason      = "Education" 
  }

  # Merge with optional extra tags
  all_tags = merge(local.common_tags, var.extra_tags)
}
