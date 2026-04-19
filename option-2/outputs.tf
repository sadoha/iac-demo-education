output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.example[*].public_ip_address
}

output "example_connection_string_to_web" {
  value = "http://${azurerm_public_ip.example[0].ip_address}"
}

output "example_ssh_connection_string_to_bastion" {
  value = "ssh -i private_ssh_key ${var.username}@${azurerm_public_ip.example[0].ip_address}"
}
