terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.90.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.40.0"
    }
  }
}
