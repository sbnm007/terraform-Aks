output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.bookinfo.id
}

output "subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.aks.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.bookinfo.name
}

output "subnet_name" {
  description = "Name of the AKS subnet"
  value       = azurerm_subnet.aks.name
}