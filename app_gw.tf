locals {
  backend_address_pool_name              = "${azurerm_virtual_network.rookout[0].name}-beap"
  frontend_port_name                     = "${azurerm_virtual_network.rookout[0].name}-feport"
  frontend_ip_configuration_name         = "${azurerm_virtual_network.rookout[0].name}-feip"
  frontend_private_ip_configuration_name = "${azurerm_virtual_network.rookout[0].name}-feprivip"
  gateway_ip_configuration               = "${azurerm_virtual_network.rookout[0].name}-gwip"
  http_setting_name                      = "${azurerm_virtual_network.rookout[0].name}-be-htst"
  listener_name                          = "${azurerm_virtual_network.rookout[0].name}-httplstn"
  request_routing_rule_name              = "${azurerm_virtual_network.rookout[0].name}-rqrt"
  redirect_configuration_name            = "${azurerm_virtual_network.rookout[0].name}-rdrcfg"
}

# Datastore

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

  # autoscale_configuration {
  #   min_capacity = 1
  #   max_capacity = 5
  # }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration
    subnet_id = azurerm_subnet.frontend[0].id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.datastore[0].id
  }

  frontend_ip_configuration {
    name                          = local.frontend_private_ip_configuration_name
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.frontend[0].id
    private_ip_address            = "172.30.1.10"
  }

  # ssl_certificate {
  #   name                = "datastore-certificate"
  #   key_vault_secret_id = var.datastore_vault_certificate_id
  # }
  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = 
  # }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [azurerm_container_group.datastore[0].ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
    #ssl_certificate_name           = "datastore-certificate"
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

# resource "azurerm_application_gateway" "controller" {
#   count = var.deploy_app_gw && var.internal_controller_app_gw == false ? 1 : 0

#   name                = "${var.environment}-rookout-controller-appgateway"
#   resource_group_name = local.resource_group_name
#   location            = local.resource_group_location

#   sku {
#     name     = "Standard_Small"
#     tier     = "Standard"
#     capacity = 1
#   }

#   # autoscale_configuration {
#   #   min_capacity = 1
#   #   max_capacity = 5
#   # }

#   gateway_ip_configuration {
#     name      = local.gateway_ip_configuration
#     subnet_id = azurerm_subnet.frontend[0].id
#   }

#   frontend_port {
#     name = local.frontend_port_name
#     port = 80
#   }

#   frontend_ip_configuration {
#     name                 = local.frontend_ip_configuration_name
#     public_ip_address_id = azurerm_public_ip.controller[0].id
#   }

# #   ssl_certificate {
# #     name     = "certificate"
# #     key_vault_secret_id =
# #   }

#   backend_address_pool {
#     name         = local.backend_address_pool_name
#     ip_addresses = [azurerm_container_group.controller.ip_address]
#   }

#   backend_http_settings {
#     name                  = local.http_setting_name
#     cookie_based_affinity = "Disabled"
#     path                  = "/"
#     port                  = 7488
#     protocol              = "Http"
#     request_timeout       = 60
#   }

#   http_listener {
#     name                           = local.listener_name
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Http"
#     #ssl_certificate_name           = "certificate"
#   }

#   request_routing_rule {
#     name                       = local.request_routing_rule_name
#     rule_type                  = "Basic"
#     http_listener_name         = local.listener_name
#     backend_address_pool_name  = local.backend_address_pool_name
#     backend_http_settings_name = local.http_setting_name
#   }

#   tags = local.tags

# }