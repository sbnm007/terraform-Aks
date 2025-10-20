# Local values for common configurations

# Resource Group
resource "azurerm_resource_group" "bookinfo" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source = "../modules/networking"

  cluster_name          = var.cluster_name
  location              = azurerm_resource_group.bookinfo.location
  resource_group_name   = azurerm_resource_group.bookinfo.name
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
  tags                  = var.tags

  depends_on = [azurerm_resource_group.bookinfo]
}

# AKS Cluster Module
module "cluster" {
  source = "../modules/cluster"

  cluster_name        = var.cluster_name
  location            = azurerm_resource_group.bookinfo.location
  resource_group_name = azurerm_resource_group.bookinfo.name
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  subnet_id           = module.networking.subnet_id
  service_cidr        = var.service_cidr
  dns_service_ip      = var.dns_service_ip
  tags                = var.tags

  depends_on = [module.networking]
}