data "http" "my_current_public_ip" { url = "https://ipv4.icanhazip.com" }

resource "azurerm_resource_group" "example" {
  location = "swedencentral"
  name     = "rg-example-dev-swec-01"
}

module "example" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm"

  basename            = trimprefix(azurerm_resource_group.example.name, "rg-")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  public_network_access = true
  allowed_ips           = [chomp(data.http.my_current_public_ip.response_body)]

  # Enables the creation of role assignments for AI Services to interact via
  # Entra ID (Managed Identities). Requires the user to have at least the
  # Owner role on the resource group. If disabled, role assignments must be
  # created manually. See the 'create_rbac' input variable for details.
  # create_rbac = true # (default)
}
