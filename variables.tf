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

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "bookinfo-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.31.10"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
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