# ==============================================================================
# Security Module - Zero-Trust Network Security Groups & Associations
# ==============================================================================

locals {
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
# 1. Web Tier NSG (nsg-web)
# Ingress: Allow HTTPS (443) from Internet
# Ingress: DenyAllInbound fallback (Zero-Trust)
# ------------------------------------------------------------------------------
resource "azurerm_network_security_group" "web" {
  name                = "nsg-web-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.mandatory_tags

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    description                = "Allow inbound HTTPS traffic from the Internet to Web tier"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Zero-Trust default: Deny all unapproved inbound traffic"
  }
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = var.web_subnet_id
  network_security_group_id = azurerm_network_security_group.web.id
}

# ------------------------------------------------------------------------------
# 2. Application Tier NSG (nsg-app)
# Ingress: Allow TCP 8080 strictly from web_subnet_cidr
# Ingress: DenyAllInbound fallback (Zero-Trust)
# ------------------------------------------------------------------------------
resource "azurerm_network_security_group" "app" {
  name                = "nsg-app-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.mandatory_tags

  security_rule {
    name                       = "Allow-Web-To-App-TCP-8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = var.web_subnet_cidr
    destination_address_prefix = "*"
    description                = "Allow inbound application traffic on port 8080 strictly from Web tier subnet"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Zero-Trust default: Deny all unapproved inbound traffic"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = var.app_subnet_id
  network_security_group_id = azurerm_network_security_group.app.id
}

# ------------------------------------------------------------------------------
# 3. Database Tier NSG (nsg-db)
# Ingress: Allow TCP 5432 strictly from app_subnet_cidr
# Ingress: DenyAllInbound fallback (Zero-Trust)
# ------------------------------------------------------------------------------
resource "azurerm_network_security_group" "db" {
  name                = "nsg-db-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.mandatory_tags

  security_rule {
    name                       = "Allow-App-To-DB-TCP-5432"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = var.app_subnet_cidr
    destination_address_prefix = "*"
    description                = "Allow inbound PostgreSQL traffic on port 5432 strictly from App tier subnet"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Zero-Trust default: Deny all unapproved inbound traffic"
  }
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db.id
}
