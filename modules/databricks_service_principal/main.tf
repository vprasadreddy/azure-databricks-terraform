data "azuread_service_principal" "databricks_service_principal" {
  for_each     = var.service_principal_variables
  display_name = each.value.azuread_service_principal_name
}

resource "databricks_service_principal" "service_principal" {
  for_each                   = var.service_principal_variables
  application_id             = data.azuread_service_principal.databricks_service_principal[each.key].client_id
  display_name               = each.value.databricks_service_principal_display_name
  external_id                = each.value.external_id
  allow_cluster_create       = each.value.allow_cluster_create
  allow_instance_pool_create = each.value.allow_instance_pool_create
  databricks_sql_access      = each.value.databricks_sql_access
  workspace_access           = each.value.workspace_access
  active                     = each.value.active
  force_delete_repos         = each.value.force_delete_repos
  force_delete_home_dir      = each.value.force_delete_home_dir
  disable_as_user_deletion   = each.value.disable_as_user_deletion
  provider                   = databricks.workspace
}
