locals {
  tags = {
    terraform   = true
    Environment = var.environment
    Service     = "rookout"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rookout" {
  name     = "${var.environment}-rookout-ResourceGroup"
  location = var.location

  tags = local.tags
}

resource "azurerm_service_plan" "controller" {
  name                = "${var.environment}-rookout-controller-plan"
  location            = azurerm_resource_group.rookout.location
  resource_group_name = azurerm_resource_group.rookout.name
  os_type             = "Linux"
  sku_name            = "P2v2"
}

