#Provider Configuration
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

# Networking Module
module "networking" {
  source = "./modules/networking"

  cluster_name        = var.cluster_name
  location            = azurerm_resource_group.bookinfo.location
  resource_group_name = azurerm_resource_group.bookinfo.name
  tags                = var.tags

  depends_on = [azurerm_resource_group.bookinfo]
}

# AKS Cluster Module
module "cluster" {
  source = "./modules/cluster"

  cluster_name        = var.cluster_name
  location            = azurerm_resource_group.bookinfo.location
  resource_group_name = azurerm_resource_group.bookinfo.name
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  subnet_id           = module.networking.subnet_id
  tags                = var.tags
  depends_on          = [module.networking]
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
  value       = module.networking.vnet_id
}

output "subnet_id" {
  description = "ID of the AKS subnet"
  value       = module.networking.subnet_id
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = module.networking.nsg_id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.cluster.cluster_name
}

output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.cluster.cluster_id
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.cluster.cluster_fqdn
}

output "client_certificate" {
  description = "Client certificate for kubectl"
  value       = module.cluster.client_certificate
  sensitive   = true
}

output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = module.cluster.kube_config
  sensitive   = true
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.bookinfo.name} --name ${module.cluster.cluster_name}"
}