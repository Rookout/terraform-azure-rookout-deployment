## terraform-azure-rookout-deployment

This terraform deploying Rookout Controller and Rookout Datastore using App Service on Azure cloud.

The module implements the following architectures (public/private deployments):

<img src="https://github.com/Rookout/terraform-azure-rookout-deployment/blob/main/documentation/Azure_Deployment_Private.jpg?raw=true" width="900">


<img src="https://github.com/Rookout/terraform-azure-rookout-deployment/blob/main/documentation/Azure_Deployment_Public.jpg?raw=true" width="900">

### Prerequisites 
1. Terraform installed.
2. ([azure quickstart-configure of terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/quickstart-configure)).
3. Create a `provider.tf` as examplined in previous guide.
4. Get your organizational Rookout token, and pass it as a variable to this module
   ```
   rookout_token = "..."
   ```

## Usage

sdfsdfsdf

https://github.com/Rookout/terraform-azure-rookout-deployment/blob/7158d9cb9ab5ab3af397b0afd00968f693da0205/examples/private_default.tf#L1-L9

## Components


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_certificate_binding.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_certificate_binding.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_managed_certificate.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_managed_certificate) | resource |
| [azurerm_app_service_managed_certificate.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_managed_certificate) | resource |
| [azurerm_app_service_virtual_network_swift_connection.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/app_service_virtual_network_swift_connection) | resource |
| [azurerm_dns_cname_record.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_cname_record.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_ns_record.rookout](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_txt_record.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_txt_record) | resource |
| [azurerm_dns_txt_record.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_txt_record) | resource |
| [azurerm_dns_zone.sub_domain](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/dns_zone) | resource |
| [azurerm_linux_web_app.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/linux_web_app) | resource |
| [azurerm_private_dns_zone.private_zone](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.dnszonelink](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.datastore](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rookout](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/resource_group) | resource |
| [azurerm_service_plan.controller](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/service_plan) | resource |
| [azurerm_subnet.app_serivce](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/subnet) | resource |
| [azurerm_subnet.gateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/subnet) | resource |
| [azurerm_subnet.private_endpoint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.rookout](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_gateway.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/resources/virtual_network_gateway) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.selected](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/dns_zone) | data source |
| [azurerm_resource_group.selected](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.selected](https://registry.terraform.io/providers/hashicorp/azurerm/3.17.0/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_vnet"></a> [create\_vnet](#input\_create\_vnet) | Flag of creation of virtual network | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain of your applicaiton | `string` | `""` | no |
| <a name="input_domain_resource_group"></a> [domain\_resource\_group](#input\_domain\_resource\_group) | Resource group of domain hosted zone | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | This variable used for namespacing and renaming resources | `string` | `"test"` | no |
| <a name="input_existing_vnet_name"></a> [existing\_vnet\_name](#input\_existing\_vnet\_name) | Provided virtual network name, where rookout app service will be deployed | `string` | `""` | no |
| <a name="input_existing_vnet_resource_group"></a> [existing\_vnet\_resource\_group](#input\_existing\_vnet\_resource\_group) | Resource group of provided virtual network | `string` | `""` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Flag to switch the deployment to be internal | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of resources | `string` | `"northeurope"` | no |
| <a name="input_private_endpoint_subnet_cidr"></a> [private\_endpoint\_subnet\_cidr](#input\_private\_endpoint\_subnet\_cidr) | CIDR of private endpoint, for internal deployment | `string` | `"10.10.0.64/26"` | no |
| <a name="input_rookout_token"></a> [rookout\_token](#input\_rookout\_token) | Rookout's org token | `string` | n/a | yes |
| <a name="input_subnet_app_serivce_cidr"></a> [subnet\_app\_serivce\_cidr](#input\_subnet\_app\_serivce\_cidr) | vnet subnets | `string` | `"10.10.0.0/26"` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | CIDR of vnet resource to be created | `string` | `"10.10.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_controller_deafult_hostname"></a> [controller\_deafult\_hostname](#output\_controller\_deafult\_hostname) | n/a |
| <a name="output_controller_dns"></a> [controller\_dns](#output\_controller\_dns) | n/a |
| <a name="output_datastore_deafult_hostname"></a> [datastore\_deafult\_hostname](#output\_datastore\_deafult\_hostname) | n/a |
| <a name="output_datastore_dns"></a> [datastore\_dns](#output\_datastore\_dns) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->