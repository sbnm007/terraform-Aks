
# Core Environment Variables
variable "location" {
  description = "Azure region where resources are deployed"
  type        = string
  #Default Region
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}


# AKS Configuration
variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  #default version being used
  default     = "1.31.10" You may keep this default if ALL environments use the same region.
}

variable "node_count" {
  description = "Number of nodes in the AKS node pool"
  type        = number
}

variable "node_vm_size" {
  description = "VM size for nodes"
  type        = string
  # Dev and prod use the same VM size.
  default     = "Standard_B2s"
}


# Networking Configuration
variable "vnet_address_space" {
  description = "Virtual network CIDR block"
  type        = list(string)
}

variable "subnet_address_prefix" {
  description = "Address prefix for AKS subnet"
  type        = list(string)
}

variable "service_cidr" {
  description = "CIDR block for Kubernetes service IPs"
  type        = string
}

variable "dns_service_ip" {
  description = "DNS IP address inside the service CIDR"
  type        = string
}


# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
