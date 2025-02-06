resource "azapi_resource" "project" {
  type      = "Microsoft.MachineLearningServices/workspaces@2024-04-01-preview"
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
