resource "random_string" "tftest" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tftest" {
  name     = "rg-tftest-dev-euw-${random_string.tftest.result}"
  location = "westeurope"
  tags = {
    terraform-module = "terraform-azurerm-vm"
  }
}

module "tftest" {
  source = "../.."

  name                = trimprefix(azurerm_resource_group.tftest.name, "rg-")
  location            = azurerm_resource_group.tftest.location
  resource_group_name = azurerm_resource_group.tftest.name
}
