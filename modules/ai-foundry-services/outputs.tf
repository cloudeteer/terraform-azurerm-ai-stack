output "ai_service_endpoint" {
  value       = azurerm_ai_services.this.endpoint
  description = "The endpoint of the AI service"
}

output "ai_service_id" {
  value       = azurerm_ai_services.this.id
  description = "The ID of the AI service"
}
