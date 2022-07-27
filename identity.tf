data "azurerm_key_vault" "rookout" {
  count = var.deploy_app_gw && var.key_vault_name != "" ? 1 : 0

  name                = var.key_vault_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_user_assigned_identity" "rookout" {
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location

  name = "${var.environment}-rookout"

  tags = local.tags

}


resource "azurerm_key_vault_access_policy" "rookout_to_key_vault" {
  count = var.deploy_app_gw && var.key_vault_name != "" ? 1 : 0

  key_vault_id = data.azurerm_key_vault.rookout[0].id
  tenant_id    = azurerm_user_assigned_identity.rookout.tenant_id
  object_id    = azurerm_user_assigned_identity.rookout.principal_id

  certificate_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}