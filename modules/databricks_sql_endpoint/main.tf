data "databricks_current_user" "me" {
}

resource "databricks_sql_endpoint" "sql_endpoint" {
  for_each                  = var.sql_endpoint_variables
  name                      = each.value.sql_warehouse_name
  cluster_size              = each.value.sql_warehouse_cluster_size
  max_num_clusters          = each.value.max_num_clusters
  min_num_clusters          = each.value.min_num_clusters
  auto_stop_mins            = each.value.auto_stop_mins
  spot_instance_policy      = each.value.spot_instance_policy
  enable_photon             = each.value.enable_photon
  enable_serverless_compute = each.value.enable_serverless_compute
  warehouse_type            = each.value.warehouse_type
  channel {
    name = each.value.channel_name
  }
  tags {
    dynamic "custom_tags" {
      for_each = each.value.tags != null ? toset(each.value.tags) : []
      content {
        key   = custom_tags.value.key
        value = custom_tags.value.value
      }
    }
  }
  provider = databricks.workspace
}
