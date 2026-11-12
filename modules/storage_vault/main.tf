# ==============================================================================
# Storage & Key Vault Module - Secure State Storage & Secret Management
# ==============================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

data "azurerm_client_config" "current" {}

# Random unique suffix to ensure global Azure naming uniqueness
resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  special = false
  numeric = true
}

locals {
  # Storage Account name: lowercase alphanumeric only, max 24 chars
  storage_account_name = substr("st${var.environment}${random_string.suffix.result}", 0, 24)
  # Key Vault name: alphanumeric and hyphens, max 24 chars
  key_vault_name = substr("kv-${var.environment}-${random_string.suffix.result}", 0, 24)

  # Fallback to current authenticated tenant ID if not explicitly overridden
  tenant_id = var.tenant_id != "" ? var.tenant_id : try(data.azurerm_client_config.current.tenant_id, "00000000-0000-0000-0000-000000000000")

  mandatory_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Multi-Env-Azure-IaC"
    },
    var.custom_tags
  )
}

# ------------------------------------------------------------------------------
# 1. Azure Storage Account (Standard_LRS, TLS 1.2, Private)
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "state_artifacts" {
  name                            = local.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = local.mandatory_tags
}

# ------------------------------------------------------------------------------
# 2. Azure Key Vault (Standard SKU, RBAC, Purge Protection disabled for clean destroy)
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "vault" {
  name                       = local.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = local.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  rbac_authorization_enabled = true
  tags                       = local.mandatory_tags
}
