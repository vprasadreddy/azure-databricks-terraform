data "databricks_current_user" "me" {
  provider = databricks.workspace
}

locals {
  tasks_list = flatten([
    for job_key, job in var.databricks_job_variables : [for task_index, task in job.tasks : [
      {
        job_key                       = job_key
        job_name                      = job.job_name
        task_key                      = task.task_key
        task_cluster_name             = task.task_cluster_name
        databricks_sql_warehouse_name = task.databricks_sql_warehouse_name
      }
      ]
    ]
  ])
}

data "azuread_service_principal" "service_principal" {
  for_each     = { for key, value in var.databricks_job_variables : key => value if lookup(value, "job_run_as_azuread_service_principal_name", null) != null }
  display_name = each.value.job_run_as_azuread_service_principal_name
}

data "databricks_cluster" "cluster" {
  for_each     = { for task_index, task in local.tasks_list : "${task.job_key}-${task.task_key}" => task if lookup(task, "task_cluster_name", null) != null }
  cluster_name = each.value.task_cluster_name
  provider     = databricks.workspace
}

data "databricks_sql_warehouse" "sql_warehouse" {
  for_each = { for task_index, task in local.tasks_list : "${task.job_key}-${task.task_key}" => task if lookup(task, "databricks_sql_warehouse_name", null) != null }
  name     = each.value.databricks_sql_warehouse_name
  provider = databricks.workspace
}

resource "databricks_job" "workflow_job" {
  for_each    = var.databricks_job_variables
  name        = each.value.job_name
  description = each.value.job_description
  dynamic "job_cluster" {
    for_each = each.value.job_cluster != null ? toset(each.value.job_cluster) : []
    content {
      job_cluster_key = job_cluster.value.job_cluster_key
      dynamic "new_cluster" {
        for_each = job_cluster.value.new_cluster != null ? toset(job_cluster.value.new_cluster) : []
        content {
          cluster_name   = new_cluster.value.cluster_name
          spark_version  = new_cluster.value.spark_version
          num_workers    = new_cluster.value.num_workers
          runtime_engine = new_cluster.value.runtime_engine
          # autotermination_minutes = new_cluster.value.autotermination_minutes
          enable_elastic_disk = new_cluster.value.enable_elastic_disk
          data_security_mode  = new_cluster.value.data_security_mode
          dynamic "azure_attributes" {
            for_each = new_cluster.value.azure_attributes != null ? toset(new_cluster.value.azure_attributes) : []
            content {
              first_on_demand    = azure_attributes.value.first_on_demand
              availability       = azure_attributes.value.availability
              spot_bid_max_price = azure_attributes.value.spot_bid_max_price
            }
          }
          # node_type_id = data.databricks_node_type.node_type["${each.key}-${job_cluster.value.job_cluster_key}"].id
          node_type_id   = new_cluster.value.node_type_id
          spark_env_vars = new_cluster.value.spark_env_vars
          spark_conf     = new_cluster.value.spark_conf
          custom_tags    = new_cluster.value.custom_tags
        }
      }
    }
  }
  //Job level email notifications
  dynamic "email_notifications" {
    for_each = each.value.job_email_notifications != null ? toset(each.value.job_email_notifications) : []
    content {
      on_success = email_notifications.value.on_success
      on_failure = email_notifications.value.on_failure
      on_start   = email_notifications.value.on_failure
    }
  }
  //Job level notifications settings
  dynamic "notification_settings" {
    for_each = each.value.job_notification_settings != null ? toset(each.value.job_notification_settings) : []
    content {
      no_alert_for_skipped_runs  = notification_settings.value.no_alert_for_skipped_runs
      no_alert_for_canceled_runs = notification_settings.value.no_alert_for_canceled_runs
    }
  }
  # run_as {
  #   service_principal_name = each.value.job_run_as_azuread_service_principal_name != null ? data.azuread_service_principal.service_principal[each.key].client_id : null
  #   user_name              = (each.value.job_run_as_azuread_service_principal_name == null && each.value.job_run_as_user_name != null) ? each.value.job_run_as_user_name : null
  # }
  queue {
    enabled = each.value.queue_enabed
  }
  max_concurrent_runs = each.value.max_concurrent_runs
  timeout_seconds     = each.value.timeout_seconds
  git_source {
    url      = each.value.git_repo_url
    provider = each.value.git_provider
    branch   = each.value.git_branch_name
    # tag      = ""
    # commit   = ""
  }
  tags = each.value.tags
  dynamic "parameter" {
    for_each = each.value.job_parameters != null ? toset(each.value.job_parameters) : []
    content {
      name    = parameter.value.name
      default = parameter.value.default
    }
  }
  dynamic "task" {
    for_each = each.value.tasks != null ? toset(each.value.tasks) : []
    content {
      task_key            = task.value.task_key
      job_cluster_key     = (task.value.job_cluster_key != null && task.value.task_cluster_name == null) ? task.value.job_cluster_key : null
      existing_cluster_id = (task.value.job_cluster_key == null && task.value.task_cluster_name != null) ? data.databricks_cluster.cluster["${each.key}-${task.value.task_key}"].id : null
      run_if              = task.value.run_if
      timeout_seconds     = task.value.timeout_seconds
      retry_on_timeout    = task.value.retry_on_timeout
      dynamic "depends_on" {
        for_each = task.value.depends_on != null ? toset(task.value.depends_on) : []
        content {
          task_key = depends_on.value.task_key
        }
      }
      dynamic "notebook_task" {
        for_each = task.value.notebook_task != null ? toset(task.value.notebook_task) : []
        content {
          notebook_path = notebook_task.value.notebook_path
          source        = notebook_task.value.source
          warehouse_id  = task.value.databricks_sql_warehouse_name != null ? data.databricks_sql_warehouse.sql_warehouse["${each.key}-${task.value.task_key}"].id : null
        }
      }
      dynamic "dbt_task" {
        for_each = task.value.dbt_task != null ? toset(task.value.dbt_task) : []
        content {
          commands           = dbt_task.value.commands
          source             = dbt_task.value.source
          project_directory  = dbt_task.value.project_directory
          profiles_directory = dbt_task.value.profiles_directory
          catalog            = dbt_task.value.catalog
          schema             = dbt_task.value.schema
          warehouse_id       = task.value.databricks_sql_warehouse_name != null ? data.databricks_sql_warehouse.sql_warehouse["${each.key}-${task.value.task_key}"].id : null
        }
      }
      dynamic "library" {
        for_each = task.value.library != null ? toset(task.value.library) : []
        content {
          pypi {
            package = library.value.pypi_package
          }
        }
      }
      //task level notifications
      email_notifications {
        on_success = task.value.email_notifications.on_success
        on_failure = task.value.email_notifications.on_failure
      }
      //task level notification settings 
      notification_settings {
        no_alert_for_skipped_runs  = task.value.notification_settings.no_alert_for_skipped_runs
        no_alert_for_canceled_runs = task.value.notification_settings.no_alert_for_canceled_runs
        alert_on_last_attempt      = task.value.notification_settings.alert_on_last_attempt
      }
    }
  }
  provider = databricks.workspace
}
