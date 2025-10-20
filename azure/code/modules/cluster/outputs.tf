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

output "node_resource_group" {
  description = "Resource group where AKS creates additional resources"
  value       = azurerm_kubernetes_cluster.bookinfo.node_resource_group
}