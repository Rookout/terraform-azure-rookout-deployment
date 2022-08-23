output "resource_group_name" {
  value = azurerm_resource_group.rookout.name
}

output "controller_deafult_hostname" {
  value = "https://${azurerm_linux_web_app.controller.default_hostname}"
}

output "controller_dns" {
  value = var.internal ? "not created" : "https://${trim(azurerm_dns_cname_record.controller[0].fqdn, ".")}"
}

output "datastore_deafult_hostname" {
  value = "https://${azurerm_linux_web_app.datastore.default_hostname}"
}

output "datastore_dns" {
  value = var.internal ? "not created" : "https://${trim(azurerm_dns_cname_record.datastore[0].fqdn, ".")}"
}