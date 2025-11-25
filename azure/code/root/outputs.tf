# Essential Outputs Only
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.bookinfo.name
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.cluster.cluster_name
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.cluster.cluster_fqdn
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.bookinfo.name} --name ${module.cluster.cluster_name}"
}

output "environment_info" {
  description = "Environment information"
  value = {
    resource_group = azurerm_resource_group.bookinfo.name
    location       = azurerm_resource_group.bookinfo.location
    cluster_name   = var.cluster_name
  }
}