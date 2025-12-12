<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
module "example" {
  source = "cloudeteer/ai-stack/azurerm//modules/app-chatbot"
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (>= 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.14)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.7)

- <a name="provider_time"></a> [time](#provider\_time) (>= 0.13)



## Resources

The following resources are used by this module:

- [azapi_resource.mongo_cluster_allow_azure_services](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_update_resource.mongo_cluster](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/update_resource) (resource)
- [azurerm_container_app.api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) (resource)
- [azurerm_container_app.ui](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) (resource)
- [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) (resource)
- [azurerm_mongo_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mongo_cluster) (resource)
- [azurerm_role_assignment.api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.chatbot_storage_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.ui](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_container.chatbot_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_user_assigned_identity.api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_user_assigned_identity.ui](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_bytes.creds_iv](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) (resource)
- [random_bytes.creds_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) (resource)
- [random_bytes.jwt_refresh_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) (resource)
- [random_bytes.jwt_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) (resource)
- [random_bytes.openid_session_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) (resource)
- [random_password.mongo_cluster_administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_string.mongo_cluster_administrator_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [time_static.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) (resource)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_basename"></a> [basename](#input\_basename)

Description: The basename of all resources deployed by this module

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Name of the Azure resource group where all resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_api"></a> [api](#input\_api)

Description:
`enabled` | Enable the API component deployment.

`container_image` | Container image reference for the API backend service.
`cpu` | CPU allocation (in cores) for the API container.
`custom_domain_name` | "Custom domain name to be used for the API."
`envs` | "Map of environment variables to set in the API container."
`memory` | "Memory allocation for the API container (e.g., '0.5Gi')."

Type:

```hcl
object({
    enabled            = bool
    container_image    = optional(string, "ghcr.io/cloudeteer/cloudetair-chatbot-api:latest")
    cpu                = optional(number, 0.25)
    custom_domain_name = optional(string)
    envs               = optional(map(string), {})
    memory             = optional(string, "0.5Gi")
  })
```

Default:

```json
{
  "enabled": true
}
```

### <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry)

Description: Container registry configuration object, including registry ID, server address, and optional authentication details.

Type:

```hcl
object({
    id                   = string
    server               = string
    identity             = optional(string) # desc: default uses the identity brought by this module
    password_secret_name = optional(string)
    username             = optional(string)
    create_rbac          = optional(bool, true)
  })
```

Default: `null`

### <a name="input_entra_id_auth"></a> [entra\_id\_auth](#input\_entra\_id\_auth)

Description: Configure Entra ID OIDC authentication on the chatbot UI.

Type:

```hcl
object({
    tenant_id     = string
    client_id     = string
    client_secret = string
    # required_group = optional(string)
  })
```

Default: `null`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource group and resources will be deployed.

Type: `string`

Default: `"swedencentral"`

### <a name="input_names"></a> [names](#input\_names)

Description: Allow overwrite the names of specific resources, instead of using generated names by this module bases on `var.basename`. This can be handy when importing existing resources which name should not change, or when having custom naming convetions this module does not consider.

Type:

```hcl
object({
    container_app_ui  = optional(string)
    container_app_api = optional(string)
  })
```

Default: `{}`

### <a name="input_ui"></a> [ui](#input\_ui)

Description:
`enabled` | Enable the UI component deployment.

`container_image` | Container image reference for the UI backend service.
`cpu` | CPU allocation (in cores) for the UI container.
`envs` | "Map of environment variables to set in the UI container."
`memory` | "Memory allocation for the UI container (e.g., '0.5Gi')."
`custom_domain_name` | "Custom domain name to be used for the UI."

Type:

```hcl
object({
    enabled            = optional(bool, true)
    container_image    = optional(string, "ghcr.io/cloudeteer/cloudetair-chatbot-ui:latest")
    cpu                = optional(number, 0.25)
    custom_domain_name = optional(string)
    envs               = optional(map(string), {})
    memory             = optional(string, "0.5Gi")
  })
```

Default:

```json
{
  "enabled": true
}
```

## Outputs

The following outputs are exported:

### <a name="output_api_container_app_id"></a> [api\_container\_app\_id](#output\_api\_container\_app\_id)

Description: The Azure Container App ID of the API.

### <a name="output_api_identity"></a> [api\_identity](#output\_api\_identity)

Description: The user assigned identity used by the API container app.

Attributes:

Attribute | Description
-- | --
`id` | The ID of the User Assigned Identity.
`client_id` | The ID of the app associated with the Identity.
`principal_id` | The ID of the Service Principal object associated with the created Identity.
`tenant_id` | The ID of the Tenant which the Identity belongs to.

### <a name="output_ui_container_app_id"></a> [ui\_container\_app\_id](#output\_ui\_container\_app\_id)

Description: The Azure Container App ID of the UI.

### <a name="output_ui_identity"></a> [ui\_identity](#output\_ui\_identity)

Description: The user assigned identity used by the UI container app.

Attributes:

Attribute | Description
-- | --
`id` | The ID of the User Assigned Identity.
`client_id` | The ID of the app associated with the Identity.
`principal_id` | The ID of the Service Principal object associated with the created Identity.
`tenant_id` | The ID of the Tenant which the Identity belongs to.
<!-- END_TF_DOCS -->
