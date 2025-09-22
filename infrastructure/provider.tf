terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.6.0"
    }
  }
  required_version = ">= 1.5.7"
}

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "f3780644-8b67-4bbc-9037-bfc99c5c15ff"
}


