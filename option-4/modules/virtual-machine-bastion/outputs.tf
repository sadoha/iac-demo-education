output "virtual_machines_private_ip_address" {
  description = "Define private ip address of virtual machines"
  value       = azurerm_linux_virtual_machine.bastion.private_ip_address
}

output "network_interface_ids" {
  description = "Define network interface ids"
  value       = azurerm_network_interface.bastion.id
}

output "ssh_connection_string_to_bastion" {
  description = "Define the ssh connection string to the bastion vm"
  value = "ssh -i ${local_file.private_key.filename} ${var.username}@${azurerm_public_ip.bastion[0].ip_address}"
}
