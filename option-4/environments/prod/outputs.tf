output "resource_group_name" {
  description = "The Name which should be used for this Resource Group."
  value       = module.resource-group.resource_group_name
}

output "ssh_connection_string_to_bastion" {
  description = "Define the ssh connection string to the bastion vm"
  value       = module.virtual-machine-bastion.ssh_connection_string_to_bastion
}

output "connection_string_to_web" {
  description = "Define the URL to connect to LB from the internet"
  value       = module.load-balancer.connection_string_to_web
}

output "virtual_machines_private_ip_address" {
  value = module.virtual-machine.virtual_machines_private_ip_address 
}

output "nat_public_ip" {
  description = "Define the NAT Gateway public ip"
  value       = module.nat-gateway.nat_public_ip
}
