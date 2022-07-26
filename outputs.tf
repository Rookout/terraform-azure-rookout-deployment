output "datastore_gateway_fqdn" {
  value       = azurerm_public_ip.datastore[0].fqdn
  description = "Rookout's on-prem Datastore application gateway Public FQDN"
}

output "controller_gateway_fqdn" {
  value       = "" #azurerm_public_ip.controller[0].fqdn
  description = "Rookout's on-prem Controller application gateway Public FQDN"
}

output "vnet_id" {
  value       = var.create_vnet ? azurerm_virtual_network.rookout[0].id : "Not created"
  description = "VNET id that created"
}
