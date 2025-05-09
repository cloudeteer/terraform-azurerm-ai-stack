provider "azapi" {}

provider "azurerm" {
  # The storage account created by this module requires the use of Azure AD storage account.
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#storage_use_azuread
  storage_use_azuread = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
