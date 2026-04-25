variable "resource_group_location" {
  type          = string
  default       = "eastus"
  description   = "Location of the resource group"
}

variable "env_name" {
  type          = string
  default       = "global"
  description   = "The name of the environment"
}

variable "env_prefix" {
  type          = string
  default       = "demo"
  description   = "The environment prefix"
}

variable "storage_containers" {
  type        = list(string)
  default     = ["dev", "test", "prod"]
  description = "The name of storage containers"
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
