resource "azurerm_container_app_environment" "this" {
  name                = "cae-${var.basename}"
  location            = var.location
  resource_group_name = var.resource_group_name

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}
