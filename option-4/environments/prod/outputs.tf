output "resource_group_name" {
  value       = module.resource-group.resource_group_name
  description = "The Name which should be used for this Resource Group."
}

output "connection_string_to_web" {
  value = module.load-balancer.connection_string_to_web
}

output "virtual_machines_private_ip_address" {
  value = module.virtual-machine.virtual_machines_private_ip_address 
}
