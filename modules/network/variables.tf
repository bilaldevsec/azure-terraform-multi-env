variable "environment" {
  type        = string
  description = "Target deployment environment name (e.g., dev, prod, staging)."
}

variable "location" {
  type        = string
  description = "Azure region where network resources will be provisioned."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Custom name for the Azure Resource Group. If null, defaults to rg-<environment>."
  default     = null
}

variable "vnet_name" {
  type        = string
  description = "Custom name for the Virtual Network. If null, defaults to vnet-<environment>."
  default     = null
}

variable "vnet_cidr" {
  type        = list(string)
  description = "List of IPv4 CIDR blocks assigned to the Virtual Network address space."
}

variable "web_subnet_cidr" {
  type        = string
  description = "IPv4 CIDR block dedicated to the Web Tier subnet (snet-web)."
}

variable "app_subnet_cidr" {
  type        = string
  description = "IPv4 CIDR block dedicated to the Application Tier subnet (snet-app)."
}

variable "db_subnet_cidr" {
  type        = string
  description = "IPv4 CIDR block dedicated to the Database Tier subnet (snet-db)."
}

variable "custom_tags" {
  type        = map(string)
  description = "Optional additional resource tags to merge with mandatory baseline tags."
  default     = {}
}
