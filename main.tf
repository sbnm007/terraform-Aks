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


# Network Security Group and rule for AKS
resource "azurerm_network_security_group" "aks" {
  name                = "${var.cluster_name}-nsg"
  location            = azurerm_resource_group.bookinfo.location
  resource_group_name = azurerm_resource_group.bookinfo.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}


# Associate Network Security Group to Subnet
resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}



# AKS Cluster
resource "azurerm_kubernetes_cluster" "bookinfo" {
  name                = var.cluster_name
  location            = azurerm_resource_group.bookinfo.location
  resource_group_name = azurerm_resource_group.bookinfo.name
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.node_vm_size
    vnet_subnet_id = azurerm_subnet.aks.id
    type           = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16" # virtual ips for services
    dns_service_ip = "10.1.0.10"
  }

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
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.bookinfo.id
}

output "subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "client_certificate" {
  description = "Client certificate for kubectl"
  value       = azurerm_kubernetes_cluster.bookinfo.kube_config[0].client_certificate
  sensitive   = true
}

output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.bookinfo.kube_config_raw
  sensitive   = true
}


output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.aks.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.bookinfo.name
}

output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.bookinfo.id
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.bookinfo.fqdn
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.bookinfo.name} --name ${azurerm_kubernetes_cluster.bookinfo.name}"
}