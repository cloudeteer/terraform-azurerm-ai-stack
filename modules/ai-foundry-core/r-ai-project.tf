resource "azapi_resource" "project" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-10-01-preview"
  name      = "proj-${var.name}"
  location  = var.location
  parent_id = var.resource_group_id

  identity {
    type = "SystemAssigned"
  }

  body = {
    kind = "Project"

    properties = {
      description   = var.description
      friendlyName  = coalesce(var.friendly_name, "AI Project")
      hubResourceId = azapi_resource.hub.id
    }
  }
}

resource "azurerm_role_assignment" "project" {
  for_each = var.create_rbac ? toset([
    "Azure AI Developer",
  ]) : []

  scope                = azapi_resource.project.output.id
  role_definition_name = each.value
  principal_id         = var.ai_developer_principal_id
}
