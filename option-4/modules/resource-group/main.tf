# Create a resource group using the generated random name
resource "azurerm_resource_group" "example" {
  location  = var.location
  name      = "rg-${var.name}"
  tags      = var.tags
}
