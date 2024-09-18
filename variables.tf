# Resource Group Variables
variable "resource_group_variables" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
}

# Databricks Workspace Variables
variable "databricks_workspace_variables" {
  type = map(object({
    resource_group_name       = string
    resource_group_location   = string
    databricks_workspace_name = string
    databricks_workspace_sku  = string
    storage_account_name      = string
    storage_account_sku_name  = string
    tags                      = map(string)
  }))
}

variable "storage_account_sku_name" {
  type    = string
  default = "value"
}

# SQL Endpoint Variables
variable "sql_endpoint_variables" {
  type = map(object({
    sql_warehouse_name         = string
    sql_warehouse_cluster_size = string
    min_num_clusters           = number
    max_num_clusters           = number
    auto_stop_mins             = number
    tags = list(object({
      key   = string
      value = string
    }))
    spot_instance_policy      = string
    enable_photon             = bool
    enable_serverless_compute = bool
    warehouse_type            = string
    channel_name              = string
  }))
}

# Databricks Cluster Variables
variable "databricks_cluster_variables" {
  type = map(object({
    cluster_name            = string
    autotermination_minutes = number
    min_workers             = number
    max_workers             = number
    custom_tags             = map(string)
  }))
}

# GIT Credentials Variables
variable "databricks_git_credential_variables" {
  type = map(object({
    git_username          = string
    git_provider          = string
    personal_access_token = string
  }))
}

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

# Databricks Notebook Variables
variable "databricks_notebook_variables" {
  description = "Databricks Notebook Variables"
  type = map(object({
    source            = string # (Required)
    path_subdirectory = string # (Required) The absolute path of the notebook or directory, beginning with "/", e.g. "/Shared"
    filename          = string # (Required)
  }))
}

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

# Databricks Job variables
variable "databricks_job_variables" {
  type = map(object({
    job_name        = string
    job_description = string
    job_email_notifications = list(object({
      on_success = list(string)
      on_failure = list(string)
    }))
    job_notification_settings = list(object({
      no_alert_for_skipped_runs  = bool
      no_alert_for_canceled_runs = bool
    }))
    job_run_as_azuread_service_principal_name = string # Azure Active Directory Service Principal Name. Provide value for either job_run_as_azuread_service_principal_name or job_run_as_user_name but not both.
    job_run_as_user_name                      = string # Azure Active Directory User Email. Provide value for either job_run_as_azuread_service_principal_name or job_run_as_user_name but not both.
    job_parameters = list(object({
      name    = string
      default = string
    }))
    queue_enabed        = bool
    max_concurrent_runs = number
    timeout_seconds     = number
    job_cluster = list(object({
      job_cluster_key = string
      new_cluster = list(object({
        num_workers             = number
        cluster_name            = string
        spark_version           = string
        runtime_engine          = string
        autotermination_minutes = number
        enable_elastic_disk     = bool
        data_security_mode      = string
        azure_attributes = list(object({
          first_on_demand    = number
          availability       = string
          spot_bid_max_price = number
        }))
        node_type_id   = string
        spark_env_vars = map(string)
        spark_conf     = map(string)
        custom_tags    = map(string)
      }))
    }))
    tags = map(string)
    tasks = list(object({
      task_key          = string
      job_cluster_key   = string
      task_cluster_name = string
      run_if            = string
      timeout_seconds   = number
      retry_on_timeout  = bool
      depends_on = list(object({
        task_key = string
      }))
      databricks_sql_warehouse_name = string
      notebook_task = list(object({
        notebook_path = string
        source        = string
      }))
      dbt_task = list(object({
        commands           = list(string)
        source             = string
        project_directory  = string
        profiles_directory = string
        catalog            = string
        schema             = string
      }))
      library = list(object({
        pypi_package = string
      }))
      email_notifications = object({
        on_success = list(string)
        on_failure = list(string)
      })
      notification_settings = object({
        no_alert_for_skipped_runs  = bool
        no_alert_for_canceled_runs = bool
        alert_on_last_attempt      = bool
      })
    }))
    git_provider    = string
    git_repo_url    = string
    git_branch_name = string
  }))
}





