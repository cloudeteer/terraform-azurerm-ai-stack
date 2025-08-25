output "ai_service_custom_subdomain_name" {
  description = "The AI Search Service subdomain name used for token-based authentication."
  value       = azurerm_ai_services.this.custom_subdomain_name
}

output "ai_service_endpoint" {
  value       = azurerm_ai_services.this.endpoint
  description = "The endpoint of the AI service"
}

output "ai_service_id" {
  value       = azurerm_ai_services.this.id
  description = "The ID of the AI service"
}

output "ai_service_primary_access_key" {
  value       = azurerm_ai_services.this.primary_access_key
  description = "A primary access key which can be used to connect to the AI Services Account."
}

output "ai_service_secondary_access_key" {
  value       = azurerm_ai_services.this.secondary_access_key
  description = "A secondary access key which can be used to connect to the AI Services Account."
}

output "search_service_endpoint" {
  value       = "https://${azurerm_search_service.this.name}.search.windows.net"
  description = "The name of the AI service"
}

output "search_service_id" {
  value       = azurerm_search_service.this.id
  description = "The ID of the AI service"
}

output "search_service_name" {
  value       = azurerm_search_service.this.name
  description = "The name of the AI service"
}

output "search_service_primary_key" {
  value       = azurerm_search_service.this.primary_key
  description = "The Primary Key used for Search Service Administration."
}

output "search_service_principal_id" {
  value       = one(azurerm_search_service.this.identity[*].principal_id)
  description = "The principal ID of the managed identity assigned to the Azure AI Search Service"
}

output "search_service_secondary_key" {
  value       = azurerm_search_service.this.secondary_key
  description = "The Secondary Key used for Search Service Administration."
}
