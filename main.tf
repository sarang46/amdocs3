# Azure Provider source and version being used
 terraform {
  required_version = ">= 0.14" 
 	}
  provider "azurerm" {
    version = "=2.46.0"
features {}
subscription_id = var.subscription_id
	client_id       = var.client_id
	client_secret   = var.client_secret
	tenant_id       = var.tenant_id
}
resource "azurerm_resource_group" "sarangdemo" {
  name     = "sarangrtf-rg3"
  location = "uksouth"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "sarangtf-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sarangdemo.location
  resource_group_name = azurerm_resource_group.sarangdemo.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "sarangtf-subnet"
  resource_group_name  = azurerm_resource_group.sarangdemo.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "sarangtf-nsg"
  location            = azurerm_resource_group.sarangdemo.location
  resource_group_name = azurerm_resource_group.sarangdemo.name
}
resource "azurerm_network_interface" "nic" {
  name                = "sarangtf-nic"
  location            = azurerm_resource_group.sarangdemo.location
  resource_group_name = azurerm_resource_group.sarangdemo.name

  ip_configuration {
    name                          = "sjtfipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface_security_group_association" "nsgassociation" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}