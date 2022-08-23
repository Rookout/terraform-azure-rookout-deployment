data "azurerm_resource_group" "selected" {
  count = var.internal ? 0 : 1

  name = var.domain_resource_group
}

data "azurerm_dns_zone" "selected" {
  count = var.internal ? 0 : 1

  name                = var.domain_name
  resource_group_name = data.azurerm_resource_group.selected[0].name
}

resource "azurerm_dns_zone" "sub_domain" {
  count = var.internal ? 0 : 1

  name                = "rookout.${var.domain_name}"
  resource_group_name = azurerm_resource_group.rookout.name
}

resource "azurerm_dns_ns_record" "rookout" {
  count = var.internal ? 0 : 1

  name                = "rookout"
  zone_name           = data.azurerm_dns_zone.selected[0].name
  resource_group_name = var.domain_resource_group
  ttl                 = 172800

  records = azurerm_dns_zone.sub_domain[0].name_servers

  tags = local.tags
}

resource "azurerm_private_dns_zone" "private_zone" {
  count               = var.internal ? 1 : 0
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rookout.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnszonelink" {
  count = var.internal ? 1 : 0

  name                  = "${var.environment}-dnszonelink"
  resource_group_name   = azurerm_resource_group.rookout.name
  private_dns_zone_name = azurerm_private_dns_zone.private_zone[0].name
  virtual_network_id    = var.create_vnet ? azurerm_virtual_network.rookout[0].id : data.azurerm_virtual_network.selected[0].id
}
