# Output when using Individual Variables
# output "databricks_notebook_url" {
#   value = databricks_notebook.notebook.url
# }


# Output when using Map(object({})) Variables
output "databricks_notebook_output" {
  value = { for key, value in databricks_notebook.notebook : key => {
    id        = value.id
    url       = value.url
    object_id = value.object_id
    }
  }
}
