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


#  Virtual Network
resource "azurerm_virtual_network" "bookinfo" {
  name                = "${var.cluster_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.bookinfo.location
  resource_group_name = azurerm_resource_group.bookinfo.name
  
  tags = var.tags
}

# Subnet for AKS
resource "azurerm_subnet" "aks" {
  name                 = "${var.cluster_name}-subnet"
  resource_group_name  = azurerm_resource_group.bookinfo.name
  virtual_network_name = azurerm_virtual_network.bookinfo.name
  address_prefixes     = ["10.0.1.0/24"]
}
























output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.bookinfo.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.bookinfo.location
}
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.bookinfo.id
}

output "subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}