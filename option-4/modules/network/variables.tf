variable "location" {
  type          = string
  default       = ""
  description   = "A string for the location of the resource group."
}

variable "vnet_name" {
  type        = string
  default     = ""
  description = "Name of the vnet to create."
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Name of the resource group to create."
}

variable "subnet_names" {
  type        = list(string)
  default     = [""]
  description = "A list of public subnets inside the vNet."
}

variable "address_spaces" {
  description = "The list of the address spaces that is used by the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to resources."
}
