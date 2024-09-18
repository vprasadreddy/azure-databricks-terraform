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
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {
  # Configuration options
}

# provider "databricks" {
#   host = module.databricks_workspace.databricks_host
#   # azure_use_msi = true
# }

provider "databricks" {
  host = "https://${module.databricks_workspace.databricks_workspace_output["databricks_workspace_dev_1"].workspace_url}/"
  # azure_use_msi = true
}
