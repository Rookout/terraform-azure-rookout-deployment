output "datastore_gateway_fqdn" {
  value       = var.deploy_app_gw && var.deploy_datastore ? azurerm_public_ip.datastore[0].fqdn : "Not created"
  description = "Rookout's on-prem Datastore application gateway Public FQDN"
}

output "controller_gateway_fqdn" {
  value       =  var.deploy_app_gw && !var.internal_controller_app_gw ? azurerm_public_ip.controller[0].fqdn : "Not created"
  description = "Rookout's on-prem Controller application gateway Public FQDN"
}

output "controller_private_ip" {
  value       =  azurerm_container_group.datastore[0].ip_address
  description = "Rookout's on-prem Controller Instance private ip"
}

output "datastore_private_ip" {
  value       =  var.deploy_datastore ? azurerm_container_group.datastore[0].ip_address : "Not created"
  description = "Rookout's on-prem Datastore Instance private ip"
}


output "vnet_id" {
  value       = var.create_vnet ? module.vnet[0].vnet_id : "Not created"
  description = "VNET id that created"
}
