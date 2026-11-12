# ==============================================================================
# Production Environment - Outputs
# ==============================================================================

# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the provisioned Production Resource Group."
  value       = module.network.resource_group_name
}

output "resource_group_location" {
  description = "The Azure region of the Production Resource Group."
  value       = module.network.resource_group_location
}

# Virtual Network Outputs
output "vnet_name" {
  description = "The name of the Production Virtual Network."
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "The resource ID of the Production Virtual Network."
  value       = module.network.vnet_id
}

output "vnet_address_space" {
  description = "The address space CIDR prefixes allocated to the Production VNet."
  value       = module.network.vnet_address_space
}

# Subnet Outputs
output "web_subnet_id" {
  description = "Resource ID of the Web subnet (snet-web)."
  value       = module.network.web_subnet_id
}

output "app_subnet_id" {
  description = "Resource ID of the Application subnet (snet-app)."
  value       = module.network.app_subnet_id
}

output "db_subnet_id" {
  description = "Resource ID of the Database subnet (snet-db)."
  value       = module.network.db_subnet_id
}

# Security / NSG Outputs
output "web_nsg_id" {
  description = "Resource ID of the Web Network Security Group."
  value       = module.security.web_nsg_id
}

output "app_nsg_id" {
  description = "Resource ID of the Application Network Security Group."
  value       = module.security.app_nsg_id
}

output "db_nsg_id" {
  description = "Resource ID of the Database Network Security Group."
  value       = module.security.db_nsg_id
}

# Storage & Key Vault Outputs
output "storage_account_name" {
  description = "Globally unique name of the Production Storage Account."
  value       = module.storage_vault.storage_account_name
}

output "storage_account_blob_endpoint" {
  description = "Blob storage primary endpoint for Terraform state and build artifacts."
  value       = module.storage_vault.storage_account_primary_blob_endpoint
}

output "key_vault_name" {
  description = "Globally unique name of the Production Key Vault."
  value       = module.storage_vault.key_vault_name
}

output "key_vault_uri" {
  description = "Production Key Vault URI for secrets and key access."
  value       = module.storage_vault.key_vault_uri
}
