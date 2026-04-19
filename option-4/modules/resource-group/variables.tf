variable "location" {
  type          = string
  default       = ""
  description   = "The Azure Region where the Resource Group should exist"
}

variable "name" {
  type          = string
  default       = ""
  description   = "The Name which should be used for this Resource Group."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to the Resource Group."
}
