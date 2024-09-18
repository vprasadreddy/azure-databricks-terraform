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
