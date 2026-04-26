output "connection_string_to_web" {
  description = "Define the URL to connect to LB from the internet"
  value       = "http://${azurerm_public_ip.example.ip_address}"
}
