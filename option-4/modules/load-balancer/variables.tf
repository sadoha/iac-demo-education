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

variable "instances_count" {
  type          = number
  default       = 2
  description   = "The number of Virtual Machines required"
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

variable "network_interface_ids" {
  default     = {}
  description = "A string that describes the network interface ids"
}

variable "network_interface_ip_conf" {
  default     = {}
  description = "A string that describes the network interface ip configuration"
}
