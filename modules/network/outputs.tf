output "resource_group_id" {
  description = "The ID of the Azure Resource Group."
  value       = azurerm_resource_group.main.id
}

output "resource_group_name" {
  description = "The name of the Azure Resource Group."
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "The Azure region/location of the Resource Group."
  value       = azurerm_resource_group.main.location
}

output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "The address space CIDR blocks configured on the Virtual Network."
  value       = azurerm_virtual_network.main.address_space
}

output "web_subnet_id" {
  description = "The resource ID of the Web subnet (snet-web)."
  value       = azurerm_subnet.web.id
}

output "web_subnet_name" {
  description = "The name of the Web subnet."
  value       = azurerm_subnet.web.name
}

output "web_subnet_cidr" {
  description = "The address prefix configured for the Web subnet."
  value       = var.web_subnet_cidr
}

output "app_subnet_id" {
  description = "The resource ID of the Application subnet (snet-app)."
  value       = azurerm_subnet.app.id
}

output "app_subnet_name" {
  description = "The name of the Application subnet."
  value       = azurerm_subnet.app.name
}

output "app_subnet_cidr" {
  description = "The address prefix configured for the Application subnet."
  value       = var.app_subnet_cidr
}

output "db_subnet_id" {
  description = "The resource ID of the Database subnet (snet-db)."
  value       = azurerm_subnet.db.id
}

output "db_subnet_name" {
  description = "The name of the Database subnet."
  value       = azurerm_subnet.db.name
}

output "db_subnet_cidr" {
  description = "The address prefix configured for the Database subnet."
  value       = var.db_subnet_cidr
}

output "tags" {
  description = "The unified map of mandatory baseline and custom tags applied to network resources."
  value       = local.mandatory_tags
}
