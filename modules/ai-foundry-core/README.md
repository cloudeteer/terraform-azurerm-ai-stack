<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
module "ai_foundry_core" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm//modules/ai-foundry-core"

  name                = var.name
  location            = var.location
  resource_group_id   = local.resource_group_id
  resource_group_name = var.resource_group_name
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) ( >= 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.1)



## Resources

The following resources are used by this module:

- [azapi_resource.hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.project](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id)

Description: The resource group ID where the resources will be deployed.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_description"></a> [description](#input\_description)

Description: The description of this workspace.

Type: `string`

Default: `""`

### <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name)

Description: The friendly name for this workspace. This value in mutable.

Type: `string`

Default: `""`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group.

Type: `string`

Default: `"eastus"`

## Outputs

The following outputs are exported:

### <a name="output_hub_id"></a> [hub\_id](#output\_hub\_id)

Description: The Azure Foundry Hub ID
<!-- END_TF_DOCS -->
