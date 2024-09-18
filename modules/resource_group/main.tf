resource "azurerm_resource_group" "resource_group" {
  for_each = var.resource_group_variables
  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags
}

# resource "azurerm_resource_group" "resource_group" {
#   name     = var.resource_group_name
#   location = var.location
#   tags     = var.tags
# }
