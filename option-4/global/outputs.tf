output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "azurerm_storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "azurerm_storage_container_names" {
  value = [for c in azurerm_storage_container.example : c.name]
}

