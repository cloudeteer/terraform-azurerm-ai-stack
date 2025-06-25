output "hub_id" {
  value       = azapi_resource.hub.id
  description = "The Azure Foundry Hub ID"
}

output "hub_management_url" {
  description = "The management URL for the AI Foundry Hub on the Azure AI platform"
  value = format(
    "https://ai.azure.com/managementCenter/hub/overview?wsid=%s&tid=%s",
    urlencode(azapi_resource.hub.output.id),
    urlencode(data.azurerm_client_config.current.tenant_id)
  )
}

output "hub_principal_id" {
  value       = one(azapi_resource.hub.identity[*].principal_id)
  description = "The principal ID of the managed identity assigned to the Azure Foundry Hub"
}

output "key_vault_id" {
  value       = azurerm_key_vault.this.id
  description = "The Azure Key Vault ID"
}

output "project_id" {
  value       = azapi_resource.project.id
  description = "The Azure Foundry Project ID"
}

output "project_management_url" {
  description = "The management URL for the AI Foundry Project on the Azure AI platform"
  value = format(
    "https://ai.azure.com/managementCenter/project/overview?wsid=%s&tid=%s",
    urlencode(azapi_resource.project.output.id),
    urlencode(data.azurerm_client_config.current.tenant_id)
  )
}

output "project_principal_id" {
  value       = one(azapi_resource.project.identity[*].principal_id)
  description = "The principal ID of the managed identity assigned to the Azure Foundry Project"
}

output "project_url" {
  description = "The URL to access the AI Foundry Project on the Azure AI platform"
  value = format(
    "https://ai.azure.com/build/overview?wsid=%s&tid=%s",
    urlencode(azapi_resource.project.output.id),
    urlencode(data.azurerm_client_config.current.tenant_id)
  )
}

output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "The Azure Storage Account ID"
}
