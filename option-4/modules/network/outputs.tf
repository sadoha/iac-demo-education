output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.example.id
}

output "vnet_name" {
  description = "The name of the newly created vNet"
  value       = azurerm_virtual_network.example.name
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.example.location
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.example.address_space
}

output "subnets_id" {
  description = "The ids of subnets created inside the newly created vNet"
  value       = azurerm_subnet.example.*.id
}

output "subnets_name" {
  description = "The names of subnets created inside the newly created vNet"
  value       = azurerm_subnet.example.*.name
}

output "subnets_address_prefixes" {
  description = "The names of subnets created inside the newly created vNet"
  value       = azurerm_subnet.example.*.address_prefixes
}
