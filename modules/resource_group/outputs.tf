output "resource_group_output" {
  value = { for key, value in azurerm_resource_group.resource_group : key => {
    id = value.id
    }
  }
}
