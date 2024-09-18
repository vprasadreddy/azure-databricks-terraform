output "databricks_workspace_output" {
  value = { for key, value in azurerm_databricks_workspace.databricks_workspace : key => {
    workspace_url = value.workspace_url
    id            = value.id
    }
  }
}
