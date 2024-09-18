# Databricks Permissions Variables

variable "databricks_permissions_variables" {
  type = map(object({
    job_name     = string # (Required) Provide value for either job_name or cluster_name but not both.
    cluster_name = string # (Required) Provide value for either job_name or cluster_name but not both.
    access_control = map(object({
      user_name                      = string # (Optional) Name of the user.
      azuread_service_principal_name = string # (Optional) Application ID of the service_principal.
      permission_level               = string # (Required) Permission level according to specific resource. CAN_READ, CAN_USE, CAN_RUN, CAN_MANAGE, CAN_VIEW, CAN_QUERY
      group_name                     = string # (Optional) Name of the group. We recommend setting permissions on groups.
    }))
  }))
}
