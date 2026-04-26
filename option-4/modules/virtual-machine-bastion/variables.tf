variable "location" {
  type          = string
  default       = ""
  description   = "A string for the location of the resource group."
}

variable "name" {
  type        = string
  default     = ""
  description = "Name of resources to create."
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Name of the resource group to create."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to resources."
}

variable "subnet_id" {
  default     = {}
  description = "A string that describes the subnets ID"
}

variable "instances_count" {
  type          = number
  default       = 1
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

variable "create_public_ip" {
  type        = bool
  default     = true
  description = "Create the public ip if it exists, else null"
}
