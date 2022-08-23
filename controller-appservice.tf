locals {
  controller_env_variables = {
    ROOKOUT_TOKEN                  = var.rookout_token
    ROOKOUT_DOP_NO_SSL_VERIFY      = false
    ONPREM_ENABLED                 = true
    ROOKOUT_CONTROLLER_SERVER_MODE = "PLAIN"
    ROOKOUT_ENFORCE_TOKEN          = true
    WEBSITES_PORT                  = 7488
  }

}

resource "azurerm_linux_web_app" "controller" {
  name                = "${var.environment}-rookout-controller-app"
  location            = azurerm_resource_group.rookout.location
  resource_group_name = azurerm_resource_group.rookout.name
  service_plan_id     = azurerm_service_plan.controller.id

  site_config {
    #websockets_enabled = true #default = false
    application_stack {
      docker_image     = "rookout/controller"
      docker_image_tag = "latest"
    }
  }

  app_settings = local.controller_env_variables
  tags         = local.tags
}

resource "azurerm_dns_txt_record" "controller" {
  count = var.internal ? 0 : 1

  name                = "asuid.${azurerm_dns_cname_record.controller[0].name}"
  zone_name           = azurerm_dns_zone.sub_domain[0].name
  resource_group_name = azurerm_dns_zone.sub_domain[0].resource_group_name
  ttl                 = 300

  record {
    value = azurerm_linux_web_app.controller.custom_domain_verification_id
  }

  tags = local.tags
}

resource "azurerm_dns_cname_record" "controller" {
  count = var.internal ? 0 : 1

  name                = "controller"
  zone_name           = azurerm_dns_zone.sub_domain[0].name
  resource_group_name = azurerm_dns_zone.sub_domain[0].resource_group_name
  ttl                 = 300
  record              = azurerm_linux_web_app.controller.default_hostname

  tags = local.tags
}

resource "azurerm_app_service_custom_hostname_binding" "controller" {
  count = var.internal ? 0 : 1

  hostname            = trim(azurerm_dns_cname_record.controller[0].fqdn, ".")
  app_service_name    = azurerm_linux_web_app.controller.name
  resource_group_name = azurerm_resource_group.rookout.name

  depends_on = [azurerm_dns_txt_record.controller[0]]

}

resource "azurerm_app_service_managed_certificate" "controller" {
  count = var.internal ? 0 : 1

  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.controller[0].id
}

resource "azurerm_app_service_certificate_binding" "controller" {
  count = var.internal ? 0 : 1

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.controller[0].id
  certificate_id      = azurerm_app_service_managed_certificate.controller[0].id
  ssl_state           = "SniEnabled"
}

