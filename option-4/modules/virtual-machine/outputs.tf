output "connection_string_to_web" {
  description = "Define the URL to connect to VM from the internet"
  value       = "http://${azurerm_linux_virtual_machine.example[0].private_ip_address}"
}

output "virtual_machines_private_ip_address" {
  description = "Define private ip address of virtual machines"
  value       = azurerm_linux_virtual_machine.example[*].private_ip_address
}

output "network_interface_ids" {
  description = "Define network interface ids"
  value       = azurerm_network_interface.example[*].id
}

output "network_interface_ip_configuration" {
  description = "Define network interface ip configuration"
  value       = azurerm_network_interface.example[*].ip_configuration[0].name
}

output "instances_count" {
  description = "Define the instances value"
  value       = var.instances_count
}
