# Core Environment Variables
location              = "West Europe"
resource_group_name   = "bookinfo-dev-rg"
cluster_name          = "bookinfo-dev-aks"

# AKS Configuration
kubernetes_version    = "1.31.10"
node_count            = 1
node_vm_size          = "Standard_B2s"

# Networking Configuration (separate CIDR ranges for dev)
vnet_address_space    = ["10.100.0.0/16"]
subnet_address_prefix = ["10.100.1.0/24"]
service_cidr          = "10.101.0.0/16"
dns_service_ip        = "10.101.0.10"

# Tags
tags = {
  Environment = "dev"
  Project     = "bookinfo"
}
