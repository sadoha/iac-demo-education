variable "resource_group_location" {
  type          = string
  default       = "eastus"
  description   = "Location of the resource group"
}

variable "env_name" {
  type          = string
  default       = "dev-01"
  description   = "The name of the environment"
}

variable "env_prefix" {
  type          = string
  default       = "demo"
  description   = "The environment prefix"
}

variable "instances_count" {
  type          = number
  default       = 1
  description   = "The number of Virtual Machines required"
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
    Location    = var.resource_group_location
    ManagedBy   = "Terraform"
    Reason      = "Education" 
  }

  # Merge with optional extra tags
  all_tags = merge(local.common_tags, var.extra_tags)
}
