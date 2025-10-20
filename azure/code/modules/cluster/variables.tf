variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where AKS nodes will be deployed"
  type        = string
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}