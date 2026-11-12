# ==============================================================================
# Production Environment - Input Variables
# ==============================================================================

variable "environment" {
  type        = string
  description = "Target deployment environment identifier."
  default     = "prod"
}

variable "location" {
  type        = string
  description = "Azure region for production environment resources."
  default     = "southeastasia"
}

variable "vnet_cidr" {
  type        = list(string)
  description = "CIDR block prefix for the Production Virtual Network."
  default     = ["10.20.0.0/16"]
}

variable "web_subnet_cidr" {
  type        = string
  description = "CIDR block prefix for the Production Web Tier Subnet."
  default     = "10.20.1.0/24"
}

variable "app_subnet_cidr" {
  type        = string
  description = "CIDR block prefix for the Production App Tier Subnet."
  default     = "10.20.2.0/24"
}

variable "db_subnet_cidr" {
  type        = string
  description = "CIDR block prefix for the Production Database Tier Subnet."
  default     = "10.20.3.0/24"
}

variable "tenant_id" {
  type        = string
  description = "Azure Active Directory tenant ID. If left empty, uses current authenticated Azure CLI tenant."
  default     = ""
}

variable "custom_tags" {
  type        = map(string)
  description = "Optional additional metadata tags for the Production environment."
  default = {
    Owner       = "SRE-CloudOps"
    CostCenter  = "Production-Core"
    Criticality = "Mission-Critical"
  }
}
