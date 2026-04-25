# Create a resource group using the generated random name
resource "azurerm_resource_group" "example" {
  location  = var.resource_group_location
  name      = "rg-${var.env_prefix}-${var.env_name}"
  tags      = local.all_tags
}

# Create a random string to use for the storage account name 
resource "random_string" "example" {
  length  = 8
  special = false
  upper   = false
}

# Create an storage account for terraform *.tfstate files
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "example" {
  name                              = trim(replace("${var.env_prefix}-${var.env_name}-${random_string.example.result}", "-", ""), "")
  resource_group_name               = azurerm_resource_group.example.name
  location                          = azurerm_resource_group.example.location
  account_tier                      = "Standard"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"
  cross_tenant_replication_enabled  = false
  tags                              = local.all_tags
  depends_on                        = [random_string.example]
}

# Create a storage containers
resource "azurerm_storage_container" "example" {
  for_each              = toset(var.storage_containers)
  name                  = "container-${var.env_prefix}-${var.env_name}-${each.value}"
  storage_account_id    = azurerm_storage_account.example.id
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.example]
}
