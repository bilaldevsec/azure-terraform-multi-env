# ==============================================================================
# Development Environment - Input Variables
# ==============================================================================

variable "environment" {
  type        = string
  description = "Target deployment environment identifier."
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region for dev environment resources."
  default     = "southeastasia"
}

variable "vnet_cidr" {
  type        = list(string)
  description = "CIDR block prefix for the Dev Virtual Network."
  default     = ["10.10.0.0/16"]
}

variable "web_subnet_cidr" {
  type        = string
  description = "CIDR block prefix for the Dev Web Tier Subnet."
  default     = "10.10.1.0/24"
}

variable "app_subnet_cidr" {
  type        = string
  description = "CIDR block prefix for the Dev App Tier Subnet."
  default     = "10.10.2.0/24"
}

variable "db_subnet_cidr" {
  type        = string
  description = "CIDR block prefix for the Dev Database Tier Subnet."
  default     = "10.10.3.0/24"
}

variable "tenant_id" {
  type        = string
  description = "Azure Active Directory tenant ID. If left empty, uses current authenticated Azure CLI tenant."
  default     = ""
}

variable "custom_tags" {
  type        = map(string)
  description = "Optional additional metadata tags for the Dev environment."
  default = {
    Owner      = "DevOps-Team"
    CostCenter = "Engineering-Dev"
  }
}
