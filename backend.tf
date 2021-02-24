terraform {
  backend "azurerm" {
    resource_group_name   = "sarangtfstate"
    storage_account_name  = "sjtfstate62"
    container_name        = "tstate"
    key                   = "saranglb1.tfstate"
  }
}