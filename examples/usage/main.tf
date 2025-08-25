resource "azurerm_resource_group" "example" {
  location = "swedencentral"
  name     = "rg-example-dev-swec-01"
}

module "example" {
  source = "cloudeteer/ai-stack/azurerm"

  # Use the resource group name (without the 'rg-' prefix) as the base name for all resources
  basename            = trimprefix(azurerm_resource_group.example.name, "rg-")
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # Enable public network access for all resources.
  # This should only be used in development or non-production environments.
  public_network_access = true
  # Optionally restrict access to specific IP addresses by setting allowed_ips.
  # allowed_ips           = []

  # Automatically create role assignments for AI services using Entra ID (Managed Identities).
  # Requires the user to have at least the Owner role on the resource group.
  # If set to false, you must manually create the necessary role assignments.
  # See the 'create_rbac' input variable documentation for more details.
  create_rbac = true # (default)

  # Enable local API key authentication for services.
  # This is currently required for chatbot integration.
  local_authentication_enabled = true

  # Deploy the chatbot submodule as part of the AI stack.
  # For additional configuration options, refer to ./modules/app-chatbot/README.md
  chatbot = {
    enabled = true
  }
}
