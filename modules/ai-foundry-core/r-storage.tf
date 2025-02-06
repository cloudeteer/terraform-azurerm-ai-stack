#trivy:ignore:avd-azu-0011
resource "azurerm_storage_account" "this" {
  name                = "st${replace(var.name, "-", "")}"
  location            = var.location
  resource_group_name = var.resource_group_name

  account_replication_type        = "GRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
}
