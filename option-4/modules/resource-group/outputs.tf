output "resource_group_name" {
  value       = azurerm_resource_group.example.name
  description = "The Name which should be used for this Resource Group."
}

output "resource_group_id" {
  value       = azurerm_resource_group.example.id
  description = "The ID of the Resource Group."
}

output "resource_group_location" {
  value       = azurerm_resource_group.example.location
  description = "The Azure Region where the Resource Group should exist."
}
