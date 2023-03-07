resource "azurerm_subnet" "private_endpoint_subnet" {
  count = var.internal ? 1 : 0

  name                 = "${var.environment}-rookout-app-private-endpoint-subnet"
  resource_group_name  = azurerm_resource_group.rookout.name
  virtual_network_name = var.create_vnet ? azurerm_virtual_network.rookout[0].name : azurerm_virtual_network.selected[0].name
  address_prefixes     = [var.private_endpoint_subnet_cidr]

  enforce_private_link_endpoint_network_policies = true

}


resource "azurerm_private_endpoint" "controller" {
  count = var.internal ? 1 : 0

  name                = "${azurerm_linux_web_app.controller.name}-ctrl-endpoint"
  location            = azurerm_resource_group.rookout.location
  resource_group_name = azurerm_resource_group.rookout.name
  subnet_id           = azurerm_subnet.private_endpoint_subnet[0].id

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.private_zone[0].name
    private_dns_zone_ids = [azurerm_private_dns_zone.private_zone[0].id]
  }
  private_service_connection {
    name                           = "${azurerm_linux_web_app.controller.name}-privateconnection"
    private_connection_resource_id = azurerm_linux_web_app.controller.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "datastore" {
  count = var.internal ? 1 : 0

  name                = "${azurerm_linux_web_app.datastore.name}-db-endpoint"
  location            = azurerm_resource_group.rookout.location
  resource_group_name = azurerm_resource_group.rookout.name
  subnet_id           = azurerm_subnet.private_endpoint_subnet[0].id

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.private_zone[0].name
    private_dns_zone_ids = [azurerm_private_dns_zone.private_zone[0].id]
  }
  private_service_connection {
    name                           = "${azurerm_linux_web_app.datastore.name}-privateconnection"
    private_connection_resource_id = azurerm_linux_web_app.datastore.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}