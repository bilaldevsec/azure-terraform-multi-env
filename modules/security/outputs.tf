output "web_nsg_id" {
  description = "The ID of the Web tier Network Security Group."
  value       = azurerm_network_security_group.web.id
}

output "web_nsg_name" {
  description = "The name of the Web tier Network Security Group."
  value       = azurerm_network_security_group.web.name
}

output "app_nsg_id" {
  description = "The ID of the Application tier Network Security Group."
  value       = azurerm_network_security_group.app.id
}

output "app_nsg_name" {
  description = "The name of the Application tier Network Security Group."
  value       = azurerm_network_security_group.app.name
}

output "db_nsg_id" {
  description = "The ID of the Database tier Network Security Group."
  value       = azurerm_network_security_group.db.id
}

output "db_nsg_name" {
  description = "The name of the Database tier Network Security Group."
  value       = azurerm_network_security_group.db.name
}
