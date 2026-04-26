output "nat_public_ip" {
  description = "Define the NAT Gateway public ip"
  value       = azurerm_public_ip.nat.ip_address
}
