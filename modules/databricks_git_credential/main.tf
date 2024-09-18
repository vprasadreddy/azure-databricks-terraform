resource "databricks_git_credential" "git_credential" {
  for_each              = var.databricks_git_credential_variables
  git_username          = each.value.git_username
  git_provider          = each.value.git_provider
  personal_access_token = each.value.personal_access_token
  provider              = databricks.workspace
}
