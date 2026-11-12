# ==============================================================================
# Production Environment - Root Infrastructure Configuration
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"
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

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = false
    }
  }
}

# ------------------------------------------------------------------------------
# 1. Network Module (Resource Group, VNet, 3-Tier Subnets)
# ------------------------------------------------------------------------------
module "network" {
  source = "../../modules/network"

  environment     = var.environment
  location        = var.location
  vnet_cidr       = var.vnet_cidr
  web_subnet_cidr = var.web_subnet_cidr
  app_subnet_cidr = var.app_subnet_cidr
  db_subnet_cidr  = var.db_subnet_cidr
  custom_tags     = var.custom_tags
}

# ------------------------------------------------------------------------------
# 2. Security Module (NSGs, Zero-Trust Rules & Subnet Associations)
# ------------------------------------------------------------------------------
module "security" {
  source = "../../modules/security"

  environment         = var.environment
  location            = module.network.resource_group_location
  resource_group_name = module.network.resource_group_name
  web_subnet_id       = module.network.web_subnet_id
  app_subnet_id       = module.network.app_subnet_id
  db_subnet_id        = module.network.db_subnet_id
  web_subnet_cidr     = var.web_subnet_cidr
  app_subnet_cidr     = var.app_subnet_cidr
  custom_tags         = var.custom_tags
}

# ------------------------------------------------------------------------------
# 3. Storage & Key Vault Module (State Storage & Secret Management)
# ------------------------------------------------------------------------------
module "storage_vault" {
  source = "../../modules/storage_vault"

  environment         = var.environment
  location            = module.network.resource_group_location
  resource_group_name = module.network.resource_group_name
  tenant_id           = var.tenant_id
  custom_tags         = var.custom_tags
}
