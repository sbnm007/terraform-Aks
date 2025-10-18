variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "bookinfo-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "North Europe"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "bookinfo"
    ManagedBy   = "terraform"
  }
}