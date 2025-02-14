data "azurerm_client_config" "current" {}

data "http" "my_current_public_ip" { url = "https://ipv4.icanhazip.com" }

resource "azurerm_resource_group" "example" {
  location = "swedencentral"
  name     = "rg-example-dev-swec-01"
}

module "example" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm"

  name                = trimprefix(azurerm_resource_group.example.name, "rg-")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  create_rbac               = true
  ai_developer_principal_id = data.azurerm_client_config.current.object_id

  public_network_access = true
  allowed_ips           = [chomp(data.http.my_current_public_ip.response_body)]
}
