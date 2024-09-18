data "databricks_current_user" "me" {
  provider = databricks.workspace
}

# Databricks Notebook resource creation using Individual Variables
# resource "databricks_notebook" "notebook" {
#   path     = "${data.databricks_current_user.me.home}/${var.notebook_subdirectory}/${var.notebook_filename}"
#   language = var.notebook_language
#   source   = var.notebook_source
#   provider = databricks.workspace
# }


# Databricks Notebook resource creation using Map(object({})) Variables
resource "databricks_notebook" "notebook" {
  for_each = var.databricks_notebook_variables
  source   = each.value.source
  # path at workspace level
  path = "${each.value.path_subdirectory}/${each.value.filename}"
  # path at user level
  # path     = "${data.databricks_current_user.me.home}${each.value.path_subdirectory}/${each.value.filename}"
  provider = databricks.workspace
}
