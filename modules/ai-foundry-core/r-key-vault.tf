#trivy:ignore:avd-azu-0013
#trivy:ignore:avd-azu-0016
resource "azurerm_key_vault" "this" {
  name                = "kv${replace(var.name, "-", "")}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tenant_id = data.azurerm_client_config.current.tenant_id

  purge_protection_enabled = false
  sku_name                 = "standard"
}
