# Core Environment Variables
variable "location" {
  description = "Azure region"
  type        = string
  default     = "North Europe"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "bookinfo-dev-rg"
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "bookinfo-dev-aks"
}

# AKS Configuration
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31.10"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_B2s"
}

# Networking Configuration
variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
  default     = "10.1.0.10"
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "bookinfo"
    ManagedBy   = "terraform"
  }
}