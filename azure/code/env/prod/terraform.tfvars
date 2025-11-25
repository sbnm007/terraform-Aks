# Core Environment Variables
location              = "West Europe"
resource_group_name   = "bookinfo-prod-rg"
cluster_name          = "bookinfo-prod-aks"

# AKS Configuration
kubernetes_version    = "1.31.10"
node_count            = 2
node_vm_size          = "Standard_B2s"

# Networking Configuration
vnet_address_space    = ["10.0.0.0/16"]
subnet_address_prefix = ["10.0.1.0/24"]
service_cidr          = "10.1.0.0/16"
dns_service_ip        = "10.1.0.10"

# Tags
tags = {
  Environment = "prod"
  Project     = "bookinfo"
}
