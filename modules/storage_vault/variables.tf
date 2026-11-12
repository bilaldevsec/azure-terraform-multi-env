variable "environment" {
  type        = string
  description = "Target deployment environment name (e.g., dev, prod, staging)."
}

variable "location" {
  type        = string
  description = "Azure region where storage and key vault resources will be provisioned."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where storage and key vault resources will reside."
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID for the Key Vault. If empty, defaults to current client configuration."
  default     = ""
}

variable "custom_tags" {
  type        = map(string)
  description = "Optional additional resource tags to merge with mandatory baseline tags."
  default     = {}
}
