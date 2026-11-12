# ==============================================================================
# Network Module - Core Azure Networking & Resource Group Provisioning
# ==============================================================================

locals {
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : "rg-${var.environment}"
  vnet_name           = var.vnet_name != null ? var.vnet_name : "vnet-${var.environment}"

  # Mandatory governance tags merged with user-supplied custom tags
  mandatory_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Multi-Env-Azure-IaC"
    },
    var.custom_tags
  )
}

# 1. Primary Resource Group for Environment
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.mandatory_tags
}

# 2. Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_cidr
  tags                = local.mandatory_tags
}

# 3. Subnets - Tier 1: Web Tier Subnet
resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.web_subnet_cidr]
}

# 4. Subnets - Tier 2: Application Tier Subnet
resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_subnet_cidr]
}

# 5. Subnets - Tier 3: Database Tier Subnet
resource "azurerm_subnet" "db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.db_subnet_cidr]
}
