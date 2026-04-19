output "connection_string_to_web" {
  value = "http://${azurerm_linux_virtual_machine.example[0].private_ip_address}"
}

output "virtual_machines_private_ip_address" {
  value = azurerm_linux_virtual_machine.example[*].private_ip_address
}

output "network_interface_ids" {
  value = azurerm_network_interface.example[*].id
}

output "network_interface_ip_configuration" {
  value = azurerm_network_interface.example[*].ip_configuration[0].name
}

