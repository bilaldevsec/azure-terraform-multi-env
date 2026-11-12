output "storage_account_id" {
  description = "The ID of the Azure Storage Account."
  value       = azurerm_storage_account.state_artifacts.id
}

output "storage_account_name" {
  description = "The globally unique name of the Azure Storage Account."
  value       = azurerm_storage_account.state_artifacts.name
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint URL for the Storage Account."
  value       = azurerm_storage_account.state_artifacts.primary_blob_endpoint
}

output "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  value       = azurerm_key_vault.vault.id
}

output "key_vault_name" {
  description = "The globally unique name of the Azure Key Vault."
  value       = azurerm_key_vault.vault.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault for accessing keys and secrets."
  value       = azurerm_key_vault.vault.vault_uri
}
