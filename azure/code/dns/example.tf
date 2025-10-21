# Create a DNS zone
resource "azurerm_dns_zone" "bookinfo" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.bookinfo.name
}

# Register A record for app
resource "azurerm_dns_a_record" "bookinfo_app" {
  name                = "app"
  zone_name           = azurerm_dns_zone.bookinfo.name
  resource_group_name = azurerm_resource_group.bookinfo.name
  ttl                 = 300
  records             = [azurerm_public_ip.app.ip_address]
}

# Register CNAME record for AKS
resource "azurerm_dns_cname_record" "bookinfo_aks" {
  name                = "aks"
  zone_name           = azurerm_dns_zone.bookinfo.name
  resource_group_name = azurerm_resource_group.bookinfo.name
  ttl                 = 300
  record              = module.cluster.aks_fqdn
}