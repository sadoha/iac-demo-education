output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "connection_string_to_web" {
  value = "http://${azurerm_public_ip.example.ip_address}"
}

output "virtual_machines_private_ip_address" {
  value = azurerm_linux_virtual_machine.example[*].private_ip_address
}
