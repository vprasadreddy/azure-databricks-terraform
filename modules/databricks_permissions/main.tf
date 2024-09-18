locals {
  databricks_permissions_list = flatten([for key, permission in var.databricks_permissions_variables : [for access_control_key, access_control in permission.access_control : [
    {
      main_key                       = key
      access_control_key             = access_control_key
      azuread_service_principal_name = access_control.azuread_service_principal_name
      permission_level               = access_control.permission_level
    }
    ]
    ]
  ])
}

data "azuread_service_principal" "service_principal" {
  for_each     = { for index, value in local.databricks_permissions_list : "${value.main_key}-${value.access_control_key}" => value if lookup(value, "azuread_service_principal_name", null) != null }
  display_name = each.value.azuread_service_principal_name
}

data "databricks_job" "job_id" {
  for_each = { for key, value in var.databricks_permissions_variables : key => value if lookup(value, "job_name", null) != null }
  job_name = each.value.job_name
  provider = databricks.workspace
}

data "databricks_cluster" "cluster_id" {
  for_each     = { for key, value in var.databricks_permissions_variables : key => value if lookup(value, "cluster_name", null) != null }
  cluster_name = each.value.cluster_name
  provider     = databricks.workspace
}

resource "databricks_permissions" "permissions" {
  for_each   = var.databricks_permissions_variables
  job_id     = (each.value.job_name != null && each.value.cluster_name == null) ? data.databricks_job.job_id[each.key].id : null
  cluster_id = (each.value.cluster_name != null && each.value.job_name == null) ? data.databricks_cluster.cluster_id[each.key].id : null
  dynamic "access_control" {
    for_each = each.value.access_control
    content {
      user_name = access_control.value.user_name != null && (access_control.value.azuread_service_principal_name == null && access_control.value.group_name == null) ? access_control.value.user_name : null
      # service_principal_name = access_control.value.azuread_service_principal_name != null && (access_control.value.user_name == null && access_control.value.group_name == null) ? access_control.value.azuread_service_principal_name : null
      service_principal_name = access_control.value.azuread_service_principal_name != null && (access_control.value.user_name == null && access_control.value.group_name == null) ? data.azuread_service_principal.service_principal["${each.key}-${access_control.key}"].client_id : null
      group_name             = access_control.value.group_name != null && (access_control.value.user_name == null && access_control.value.azuread_service_principal_name == null) ? access_control.value.group_name : null
      permission_level       = access_control.value.permission_level
    }
  }
  provider = databricks.workspace
}
