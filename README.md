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
module "example" {
  source = "cloudeteer/azure-ai-foundry-hub/azurerm"
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~>2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~>3.0)

- <a name="provider_random"></a> [random](#provider\_random) (~>3.0)



## Resources

The following resources are used by this module:

- [azapi_resource.AIServicesConnection](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.AIServicesResource](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.hub](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.project](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_key_vault.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_storage_account.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [random_pet.rg_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)


## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_prefix"></a> [prefix](#input\_prefix)

Description: This variable is used to name the hub, project, and dependent resources.

Type: `string`

Default: `"ai"`

### <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location)

Description: Location of the resource group.

Type: `string`

Default: `"eastus"`

### <a name="input_resource_group_name_prefix"></a> [resource\_group\_name\_prefix](#input\_resource\_group\_name\_prefix)

Description: Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription.

Type: `string`

Default: `"rg"`

### <a name="input_sku"></a> [sku](#input\_sku)

Description: The sku name of the Azure Analysis Services server to create. Choose from: B1, B2, D1, S0, S1, S2, S3, S4, S8, S9. Some skus are region specific. See https://docs.microsoft.com/en-us/azure/analysis-services/analysis-services-overview#availability-by-region

Type: `string`

Default: `"S0"`

## Outputs

The following outputs are exported:

### <a name="output_endpoint"></a> [endpoint](#output\_endpoint)

Description: n/a

### <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name)

Description: n/a

### <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name)

Description: n/a
<!-- END_TF_DOCS -->

## Contributions

We welcome all kinds of contributions, whether it's reporting bugs, submitting feature requests, or directly contributing to the development. Please read our [Contributing Guidelines](CONTRIBUTING.md) to learn how you can best contribute.

Thank you for your interest and support!

## Copyright and license

<img width=200 alt="Logo" src="https://raw.githubusercontent.com/cloudeteer/cdt-public/main/img/cdt_logo_orig_4c.svg">

© 2024 CLOUDETEER GmbH

This project is licensed under the [MIT License](LICENSE).
