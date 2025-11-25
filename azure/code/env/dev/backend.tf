terraform {
  backend "azurerm" {
    resource_group_name  = "bookinfo-admin-rg"
    storage_account_name = "tfstate389dlf88"
    container_name       = "tfstate"
    key                  = "dev/infrastructure.tfstate"
  }
}