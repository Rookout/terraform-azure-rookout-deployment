locals {
  gw_prefix                              = "${var.environment}-rookout"
  backend_address_pool_name              = "${local.gw_prefix}-beap"
  frontend_port_name                     = "${local.gw_prefix}-feport"
  frontend_ip_configuration_name         = "${local.gw_prefix}-feip"
  frontend_private_ip_configuration_name = "${local.gw_prefix}-feprivip"
  gateway_ip_configuration               = "${local.gw_prefix}-gwip"
  http_setting_name                      = "${local.gw_prefix}-be-htst"
  listener_name                          = "${local.gw_prefix}-httplstn"
  request_routing_rule_name              = "${local.gw_prefix}-rqrt"
  redirect_configuration_name            = "${local.gw_prefix}-rdrcfg"
}

################################################################################
# Rookout datastore Application Gateway resource
################################################################################

resource "azurerm_application_gateway" "datastore" {
  count = var.deploy_app_gw && var.deploy_datastore ? 1 : 0

  name                = "${var.environment}-rookout-datastore-appgateway"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration
    subnet_id = local.frontend_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = local.datastore_settings.app_gateway_port
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.datastore[0].id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    ip_addresses = [azurerm_container_group.datastore[0].ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = local.datastore_settings.container_port
    protocol              = "Http"
    request_timeout       = 60
  }


  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = "datastore-certificate"
  }

  ssl_certificate {
    name                = "datastore-certificate"
    key_vault_secret_id = var.datastore_vault_certificate_id
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.rookout.id]
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

  tags = local.tags

}

################################################################################
# Rookout controller Application Gateway resource
################################################################################

resource "azurerm_application_gateway" "controller" {
  count = var.deploy_app_gw && !var.internal_controller_app_gw ? 1 : 0

  name                = "${var.environment}-rookout-controller-appgateway"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration
    subnet_id = local.frontend_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = local.controller_settings.app_gateway_port
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.controller[0].id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [azurerm_container_group.controller.ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = local.controller_settings.container_port
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = "controller-certificate"
  }

  ssl_certificate {
    name                = "controller-certificate"
    key_vault_secret_id = var.controller_vault_certificate_id
  }
  
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.rookout.id]
  }
  
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

  tags = local.tags

}

################################################################################
# Rookout demo flask application Application Gateway resource 
################################################################################

resource "azurerm_application_gateway" "demo" {
  count = var.deploy_app_gw && var.deploy_demo_app ? 1 : 0

  name                = "${var.environment}-rookout-demo-appgateway"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration
    subnet_id = local.frontend_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = local.demo_settings.app_gateway_port
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.demo[0].id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [azurerm_container_group.demo[0].ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = local.demo_settings.container_port
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  tags = local.tags

}