<!-- markdownlint-disable first-line-h1 no-inline-html -->

> [!NOTE]
> This repository is publicly accessible as part of our open-source initiative. We welcome contributions from the community alongside our organization's primary development efforts.

---

# terraform-module-template

[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-blue.svg)](https://github.com/cloudeteer/terraform-module-template/releases)

Terraform Module Template

<!-- BEGIN_TF_DOCS -->
## Usage

This example demonstrates the usage of this Terraform module with default settings.

```hcl
resource "azurerm_resource_group" "this" {
  location = "germanywestcentral"
  name     = "rg-example-dev-gwc-01"
}

module "example" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm"

  name                = trimprefix(azurerm_resource_group.this.name, "rg-")
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~>2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.1)



## Resources

The following resources are used by this module:

- [azapi_resource.ai_services_connection](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.project](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_ai_services.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_services) (resource)
- [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group.

Type: `string`

Default: `"eastus"`

### <a name="input_sku"></a> [sku](#input\_sku)

Description: The sku name of the Azure Analysis Services server to create. Choose from: B1, B2, D1, S0, S1, S2, S3, S4, S8, S9. Some skus are region specific. See https://docs.microsoft.com/en-us/azure/analysis-services/analysis-services-overview#availability-by-region

Type: `string`

Default: `"S0"`

### <a name="input_workspace_description"></a> [workspace\_description](#input\_workspace\_description)

Description: The description of this workspace.

Type: `string`

Default: `""`

### <a name="input_workspace_friendly_name"></a> [workspace\_friendly\_name](#input\_workspace\_friendly\_name)

Description: The friendly name for this workspace. This value in mutable.

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### <a name="output_endpoint"></a> [endpoint](#output\_endpoint)

Description: The endpoint used to connect to the AI Services Account.

### <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name)

Description: The ID of the Azure AI project workspace.
<!-- END_TF_DOCS -->

## Contributions

We welcome all kinds of contributions, whether it's reporting bugs, submitting feature requests, or directly contributing to the development. Please read our [Contributing Guidelines](CONTRIBUTING.md) to learn how you can best contribute.

Thank you for your interest and support!

## Copyright and license

<img width=200 alt="Logo" src="https://raw.githubusercontent.com/cloudeteer/cdt-public/main/img/cdt_logo_orig_4c.svg">

© 2024 CLOUDETEER GmbH

This project is licensed under the [MIT License](LICENSE).
