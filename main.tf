# Configure Azure Provider
terraform {
  required_providers {
     azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.59.0"
    } 
  }
  backend "azurerm" {
resource_group_name   = "na-resource-group"
storage_account_name  = "heydevopsterraformtstate"
container_name        = "tstate"
key                   = "KEY"
}
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}

  skip_provider_registration = "true"
}

variable "prefix" {
  default = "terraform"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-ResourceGroup1"
  location = "Central India"
}







