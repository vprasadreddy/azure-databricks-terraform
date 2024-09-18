# Resource Group Variables
resource_group_variables = {
  resource_group_dev_1 = {
    name     = "databricks-rg-dev"
    location = "eastus"
    tags = {
      "Owner"       = "Prasad"
      "Environment" = "Dev"
    }
  }
}

# Databricks Workspace Variables
databricks_workspace_variables = {
  databricks_workspace_dev_1 = {
    resource_group_name       = "databricks-rg-dev"
    resource_group_location   = "eastus"
    databricks_workspace_name = "demo-databricks-wokspace-dev"
    databricks_workspace_sku  = "premium"
    storage_account_name      = "dbwokspacestgdev"
    storage_account_sku_name  = "Standard_LRS"
    tags = {
      Owner       = "Prasad"
      Environment = "Dev"
    }
  }
}

# SQL Endpoint Variables
sql_endpoint_variables = {
  sql_endpoint_dev_1 = {
    sql_warehouse_name         = "demo-sql-warehouse-dev"
    sql_warehouse_cluster_size = "Small"
    min_num_clusters           = 1
    max_num_clusters           = 1
    auto_stop_mins             = null
    tags = [{
      key   = "Created_By"
      value = "Prasad"
      },
      {
        key   = "Environment"
        value = "Dev"
      }]
    spot_instance_policy      = null
    enable_photon             = true
    enable_serverless_compute = false
    warehouse_type            = "CLASSIC"
    channel_name              = null
  }
}

# Databricks Cluster Variables
databricks_cluster_variables = {
  databricks_cluster_dev_1 = {
    cluster_name            = "demo-cluster-dev"
    autotermination_minutes = 20
    min_workers             = 1
    max_workers             = 5
    custom_tags = {
      "Owner"       = "Prasad"
      "Environment" = "Dev"
    }
  }
}

# GIT Credentials Variables
databricks_git_credential_variables = {
  databricks_git_credential_dev_1 = {
    git_username          = "vprasadreddy"
    git_provider          = "gitHub"
    personal_access_token = "" #Provide github_pat_token here.
  }
}

# Service Principal Variables
service_principal_variables = {
  service_principal_dev_1 = {
    azuread_service_principal_name            = "databricks-workspace-sp" #(Required) This is the Azure Application ID of the given Azure service principal and will be their form of access and identity. For Databricks-managed service principals this value is auto-generated.
    databricks_service_principal_display_name = "databricks-workspace-sp" #(Required) This is an alias for the service principal and can be the full name of the service principal.
    external_id                               = null                      #(Optional) ID of the service principal in an external identity provider.
    allow_cluster_create                      = true                      #(Optional) Allow the service principal to have cluster create privileges. Defaults to false. More fine grained permissions could be assigned with databricks_permissions and cluster_id argument. Everyone without
    allow_instance_pool_create                = true                      #(Optional) Allow the service principal to have instance pool create privileges. Defaults to false. More fine grained permissions could be assigned with databricks_permissions and instance_pool_id argument.
    databricks_sql_access                     = true                      #(Optional) This is a field to allow the group to have access to Databricks SQL feature through databricks_sql_endpoint.
    workspace_access                          = true                      #(Optional) This is a field to allow the group to have access to Databricks Workspace.
    active                                    = true                      #(Optional) Either service principal is active or not. True by default, but can be set to false in case of service principal deactivation with preserving service principal assets.
    force_delete_repos                        = false                     #(Optional) This flag determines whether the service principal's repo directory is deleted when the user is deleted. It will have no impact when in the accounts SCIM API. False by default.
    force_delete_home_dir                     = false                     #(Optional) This flag determines whether the service principal's home directory is deleted when the user is deleted. It will have no impact when in the accounts SCIM API. False by default.
    disable_as_user_deletion                  = true                      #(Optional) Deactivate the service principal when deleting the resource, rather than deleting the service principal entirely. Defaults to true when the provider is configured at the account-level and false when configured at the workspace-level. This flag is exclusive to force_delete_repos and force_delete_home_dir flags.
  }
}

# Databricks Notebook Variables
databricks_notebook_variables = {
  databricks_notebook_dev_1 = {
    source            = "./sample-python-code.py"
    path_subdirectory = "/Shared"
    filename          = "sample-python-code.py"
  }
}

# Databricks Workflow Job Variables
databricks_job_variables = {
  databricks_job_dev_1 = {
    job_name        = "sample-python-job"
    job_description = "Sample Python Job"
    job_email_notifications = [{
      on_failure = ["abcd@company_email.com"]
      on_success = ["abcd@company_email.com"]
    }]
    job_notification_settings = [{
      no_alert_for_skipped_runs  = false
      no_alert_for_canceled_runs = false
    }]
    job_run_as_azuread_service_principal_name = "databricks-workspace-sp"
    job_run_as_user_name                      = null
    job_parameters = [{
      name    = "parameter_name1"
      default = "parameter_value1"
      },
      {
        name    = "parameter_name2"
        default = "parameter_value2"
    }]
    queue_enabed        = true
    max_concurrent_runs = 5
    timeout_seconds     = null
    job_cluster = [{
      job_cluster_key = "cli_dbt"
      new_cluster = [{
        num_workers             = 2
        cluster_name            = ""
        spark_version           = "13.3.x-scala2.12"
        runtime_engine          = "PHOTON"
        autotermination_minutes = null
        enable_elastic_disk     = true
        data_security_mode      = "SINGLE_USER"
        azure_attributes = [{
          first_on_demand    = 1
          availability       = "ON_DEMAND_AZURE"
          spot_bid_max_price = -1
        }]
        node_type_id = "Standard_DS3_v2"
        spark_env_vars = {
          PYSPARK_PYTHON  = "/databricks/python3/bin/python"
          PYSPARK_PYTHON2 = "/databricks/python3/bin/python2"
          PYSPARK_PYTHON3 = "/databricks/python3/bin/python3"
        }
        spark_conf = {
          "spark.master"                     = "local[*, 4]"
          "spark.databricks.cluster.profile" = "singleNode"
        }
        custom_tags = {
          "ResourceClass" = "SingleNode"
        }
      }]
    }]
    tags = {
      Owner       = "Prasad"
      Environment = "Dev"
    }
    tasks = [{
      task_key                      = "Task1"
      job_cluster_key               = "cli_dbt"
      task_cluster_name             = null
      run_if                        = null
      timeout_seconds               = null
      retry_on_timeout              = false
      depends_on                    = null
      databricks_sql_warehouse_name = null
      notebook_task = [{
        notebook_path = "sample-python-code"
        source        = "GIT"
      }]
      dbt_task = null
      library  = null
      email_notifications = {
        on_success = ["abcd@company_email.com"]
        on_failure = ["abcd@company_email.com"]
      }
      notification_settings = {
        no_alert_for_skipped_runs  = false
        no_alert_for_canceled_runs = false
        alert_on_last_attempt      = false
      }
      },
      {
        task_key          = "Task2"
        job_cluster_key   = null
        task_cluster_name = "demo-cluster-dev"
        run_if            = null
        timeout_seconds   = null
        retry_on_timeout  = false
        depends_on = [{
          task_key = "Task1"
        }]
        databricks_sql_warehouse_name = "Serverless Starter Warehouse"
        notebook_task                 = null
        dbt_task = [{
          commands           = ["dbt deps", "dbt debug --connection"]
          source             = "GIT"
          project_directory  = "."
          profiles_directory = null
          catalog            = null
          schema             = null
        }]
        library = [
          {
            pypi_package = "dbt-databricks>=1.0.0,<2.0.0"
          },
          {
            pypi_package = "fbprophet==0.6"
          }
        ]
        email_notifications = {
          on_success = ["abcd@company_email.com"]
          on_failure = ["abcd@company_email.com"]
        }
        notification_settings = {
          no_alert_for_skipped_runs  = false
          no_alert_for_canceled_runs = false
          alert_on_last_attempt      = false
        }
    }]
    git_provider    = "gitHub"
    git_repo_url    = "https://github.com/vprasadreddy/azure-databricks-terraform.git"
    git_branch_name = "main"
  }
}

# Databricks Permissions Variables
databricks_permissions_variables = {
  databricks_cluster_permissions = {
    job_name     = null
    cluster_name = "demo-cluster-dev"
    access_control = {
      service_principal_access_control = {
        user_name                      = null
        azuread_service_principal_name = "databricks-workspace-sp"
        group_name                     = null
        permission_level               = "CAN_MANAGE"
      }
    }
  },
  databricks_job_permissions = {
    job_name     = "sample-python-job"
    cluster_name = null
    access_control = {
      databricks_group_access_control = {
        user_name                      = null
        azuread_service_principal_name = null
        group_name                     = "users"
        permission_level               = "CAN_MANAGE"
      }
    }
  }
}
