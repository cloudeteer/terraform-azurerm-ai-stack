resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

locals {
  storage_account_name = format("st%s%s", replace(var.basename, "/[^a-zA-Z0-9]/", ""), random_string.suffix.result)
}

resource "azurerm_storage_account" "this" {
  name                = local.storage_account_name
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = true
  default_to_oauth_authentication = true
  public_network_access_enabled   = true
  shared_access_key_enabled       = false
}

#trivy:ignore:avd-azu-0007 (HIGH): Container allows public access
resource "azurerm_storage_container" "chatbot_storage" {
  name                  = "chatbot-storage"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "blob"
}

resource "azurerm_role_assignment" "chatbot_storage_contributor" {
  scope = azurerm_storage_container.chatbot_storage.id
  # scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.ui.principal_id
}
