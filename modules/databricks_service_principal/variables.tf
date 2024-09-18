# Service Principal Variables
variable "service_principal_variables" {
  type = map(object({
    azuread_service_principal_name            = string #(Required) This is the Azure Application ID of the given Azure service principal and will be their form of access and identity. For Databricks-managed service principals this value is auto-generated.
    databricks_service_principal_display_name = string #(Required) This is an alias for the service principal and can be the full name of the service principal.
    external_id                               = string #(Optional) ID of the service principal in an external identity provider.
    allow_cluster_create                      = bool   #(Optional) Allow the service principal to have cluster create privileges. Defaults to false. More fine grained permissions could be assigned with databricks_permissions and cluster_id argument. Everyone without
    allow_instance_pool_create                = bool   #(Optional) Allow the service principal to have instance pool create privileges. Defaults to false. More fine grained permissions could be assigned with databricks_permissions and instance_pool_id argument.
    databricks_sql_access                     = bool   #(Optional) This is a field to allow the group to have access to Databricks SQL feature through databricks_sql_endpoint.
    workspace_access                          = bool   #(Optional) This is a field to allow the group to have access to Databricks Workspace.
    active                                    = bool   #(Optional) Either service principal is active or not. True by default, but can be set to false in case of service principal deactivation with preserving service principal assets.
    force_delete_repos                        = bool   #(Optional) This flag determines whether the service principal's repo directory is deleted when the user is deleted. It will have no impact when in the accounts SCIM API. False by default.
    force_delete_home_dir                     = bool   #(Optional) This flag determines whether the service principal's home directory is deleted when the user is deleted. It will have no impact when in the accounts SCIM API. False by default.
    disable_as_user_deletion                  = bool   #(Optional) Deactivate the service principal when deleting the resource, rather than deleting the service principal entirely. Defaults to true when the provider is configured at the account-level and false when configured at the workspace-level. This flag is exclusive to force_delete_repos and force_delete_home_dir flags.
  }))
}
