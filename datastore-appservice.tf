locals {
  datastore_env_variables = {
    ROOKOUT_TOKEN            = var.rookout_token
    ROOKOUT_DOP_SERVER_MODE  = "PLAIN"
    ROOKOUT_DOP_IN_MEMORY_DB = true
    ROOKOUT_DOP_PORT         = 8080
    ROOKOUT_ENFORCE_TOKEN    = true
    WEBSITES_PORT            = 8080
  }

}

resource "azurerm_linux_web_app" "datastore" {
  name                = "${var.environment}-rookout-datastore-app"
  location            = var.existing_resource_group_name == "" ? azurerm_resource_group.rookout[0].location : data.azurerm_resource_group.selected[0].location
  resource_group_name = var.existing_resource_group_name == "" ? azurerm_resource_group.rookout[0].name : data.azurerm_resource_group.selected[0].name
  service_plan_id     = azurerm_service_plan.controller.id

  site_config {
    #websockets_enabled = true #default = false
    application_stack {
      docker_image     = "rookout/data-on-prem"
      docker_image_tag = "latest"
    }
  }
  app_settings = local.datastore_env_variables
  tags         = local.tags
}

resource "azurerm_dns_txt_record" "datastore" {
  count               = var.internal ? 0 : 1
  name                = "asuid.${azurerm_dns_cname_record.datastore[0].name}"
  zone_name           = azurerm_dns_zone.sub_domain[0].name
  resource_group_name = azurerm_dns_zone.sub_domain[0].resource_group_name
  ttl                 = 300

  record {
    value = azurerm_linux_web_app.datastore.custom_domain_verification_id
  }
  tags = local.tags
}

resource "azurerm_dns_cname_record" "datastore" {
  count               = var.internal ? 0 : 1
  name                = "datastore"
  zone_name           = azurerm_dns_zone.sub_domain[0].name
  resource_group_name = azurerm_dns_zone.sub_domain[0].resource_group_name
  ttl                 = 300
  record              = azurerm_linux_web_app.datastore.default_hostname
  tags                = local.tags
}

resource "azurerm_app_service_custom_hostname_binding" "datastore" {
  count               = var.internal ? 0 : 1
  hostname            = join(".", [azurerm_dns_cname_record.datastore[0].name, azurerm_dns_cname_record.datastore[0].zone_name])
  app_service_name    = azurerm_linux_web_app.datastore.name
  resource_group_name = var.existing_resource_group_name == "" ? azurerm_resource_group.rookout[0].name : data.azurerm_resource_group.selected[0].name

  depends_on = [azurerm_dns_txt_record.datastore[0]]
}

resource "azurerm_app_service_managed_certificate" "datastore" {
  count                      = var.internal ? 0 : 1
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.datastore[0].id
}

resource "azurerm_app_service_certificate_binding" "datastore" {
  count = var.internal ? 0 : 1

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.datastore[0].id
  certificate_id      = azurerm_app_service_managed_certificate.datastore[0].id
  ssl_state           = "SniEnabled"
}
