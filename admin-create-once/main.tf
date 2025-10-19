#Provider Configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
     random = {                    
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

# Tags for all resources
locals {
  admin_tags = {
    Purpose     = "github-runner"
    ManagedBy   = "terraform"  
    Environment = "admin"
    Project     = "bookinfo-admin"  # Different from main project
  }
}

# Resource Group
resource "azurerm_resource_group" "admin" {
  name     = "bookinfo-admin-rg"  # Changed: More unique name
  location = "West Europe"        # Changed: Different region to avoid conflicts
  
  tags = local.admin_tags
}

# Virtual Network
resource "azurerm_virtual_network" "admin" {
  name                = "admin-vnet"
  address_space       = ["172.16.0.0/16"]  # Good: Different IP range
  location            = azurerm_resource_group.admin.location
  resource_group_name = azurerm_resource_group.admin.name

  tags = local.admin_tags
}

# Subnet
resource "azurerm_subnet" "admin" {
  name                 = "admin-subnet"
  resource_group_name  = azurerm_resource_group.admin.name
  virtual_network_name = azurerm_virtual_network.admin.name
  address_prefixes     = ["172.16.0.0/24"]
}

# Public IP
resource "azurerm_public_ip" "admin" {
  name                = "admin-ip"
  resource_group_name = azurerm_resource_group.admin.name
  location            = azurerm_resource_group.admin.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.admin_tags
}

# Simple Security Group - SSH from your IP only
resource "azurerm_network_security_group" "admin" {
  name                = "admin-nsg"
  location            = azurerm_resource_group.admin.location
  resource_group_name = azurerm_resource_group.admin.name

  # SSH only from your IP
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
  
  tags = local.admin_tags
}

# Network Interface
resource "azurerm_network_interface" "admin" {
  name                = "admin-nic"
  location            = azurerm_resource_group.admin.location
  resource_group_name = azurerm_resource_group.admin.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.admin.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.admin.id
  }
  
  tags = local.admin_tags
}

# Attach security group to network interface
resource "azurerm_network_interface_security_group_association" "admin" {
  network_interface_id      = azurerm_network_interface.admin.id
  network_security_group_id = azurerm_network_security_group.admin.id
}

# The Virtual Machine
resource "azurerm_linux_virtual_machine" "admin" {
  name                = "github-runner-vm" 
  resource_group_name = azurerm_resource_group.admin.name
  location            = azurerm_resource_group.admin.location
  size                = "Standard_B1s" #1 vCPU, 1GB RAM
  admin_username      = "azureuser"

  disable_password_authentication = true

  network_interface_ids = [azurerm_network_interface.admin.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/admin_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  
  tags = local.admin_tags 
}


#Configuring Remote State file Storage
#Globally unique account_name

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.admin.name
  location                 = azurerm_resource_group.admin.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public =  false
  min_tls_version = "TLS1_2"

  #Enabling versioning for blob storage
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 30
    }
    
    container_delete_retention_policy {
      days = 30
    }
  }

  tags = merge(local.admin_tags, {
    Purpose = "terraform-state-backend"
  })
}

# Terraform state files Container
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name 
  container_access_type = "private"
}

# Outputs
output "ssh_to_server" {
  description = "SSH command to connect to admin server"
  value       = "ssh azureuser@${azurerm_public_ip.admin.ip_address}"
}

output "public_ip" {
  description = "Public IP address of admin server"
  value       = azurerm_public_ip.admin.ip_address
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.admin.name
}

output "storage_account_name" {
  description = "Storage account name for Terraform state"
  value       = azurerm_storage_account.tfstate.name
}

output "storage_container_name" {
  description = "Container name for Terraform state"
  value       = azurerm_storage_container.tfstate.name
}

output "backend_config" {
  description = "Backend state file configuration for Terraform"
  value = <<-EOT
    terraform {
      backend "azurerm" {
        resource_group_name  = "${azurerm_resource_group.admin.name}"
        storage_account_name = "${azurerm_storage_account.tfstate.name}"
        container_name       = "${azurerm_storage_container.tfstate.name}"
        key                  = "infrastructure.tfstate"
      }
    }
  EOT
}