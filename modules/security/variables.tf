variable "environment" {
  type        = string
  description = "Target deployment environment name (e.g., dev, prod, staging)."
}

variable "location" {
  type        = string
  description = "Azure region where security resources will be provisioned."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where NSGs will be deployed."
}

variable "web_subnet_id" {
  type        = string
  description = "The resource ID of the Web subnet to associate with nsg-web."
}

variable "app_subnet_id" {
  type        = string
  description = "The resource ID of the App subnet to associate with nsg-app."
}

variable "db_subnet_id" {
  type        = string
  description = "The resource ID of the Database subnet to associate with nsg-db."
}

variable "web_subnet_cidr" {
  type        = string
  description = "The CIDR block of the Web subnet, authorized for App tier ingress."
}

variable "app_subnet_cidr" {
  type        = string
  description = "The CIDR block of the App subnet, authorized for Database tier ingress."
}

variable "custom_tags" {
  type        = map(string)
  description = "Optional additional resource tags to merge with mandatory baseline tags."
  default     = {}
}
