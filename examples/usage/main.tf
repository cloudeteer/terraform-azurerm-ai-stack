resource "azurerm_resource_group" "this" {
  location = "germanywestcentral"
  name     = "rg-example-dev-gwc-01"
}

module "example" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm"

  name                = trimprefix(azurerm_resource_group.this.name, "rg-")
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
