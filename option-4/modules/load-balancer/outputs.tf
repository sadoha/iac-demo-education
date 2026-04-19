output "connection_string_to_web" {
  value = "http://${azurerm_public_ip.example.ip_address}"
}
