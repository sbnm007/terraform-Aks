terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
  
  # Disable automatic resource provider registration for limited permission accounts
  skip_provider_registration = true
}

# Resource Group
resource "azurerm_resource_group" "bookinfo" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.tags
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.bookinfo.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.bookinfo.location
}