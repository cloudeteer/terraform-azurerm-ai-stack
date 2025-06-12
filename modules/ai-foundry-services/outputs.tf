output "ai_service_endpoint" {
  value       = azurerm_ai_services.this.endpoint
  description = "The endpoint of the AI service"
}

output "ai_service_id" {
  value       = azurerm_ai_services.this.id
  description = "The ID of the AI service"
}

output "search_service_id" {
  value       = azurerm_search_service.this.id
  description = "The ID of the AI service"
}

output "search_service_name" {
  value       = azurerm_search_service.this.name
  description = "The name of the AI service"
}

output "search_service_principal_id" {
  value       = one(azurerm_search_service.this.identity[*].principal_id)
  description = "The principal ID of the managed identity assigned to the Azure AI Search Service"
}
