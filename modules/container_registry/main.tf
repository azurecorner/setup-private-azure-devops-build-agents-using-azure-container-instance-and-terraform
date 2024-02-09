resource "azurerm_container_registry" "container_registry" {
  name                = var.registryName
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Standard"
  admin_enabled       = false

  tags = (merge(var.tags, tomap({
    type = "container_registry"

    })
  ))
}

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "${var.resource_group_name}-identity"

  tags = (merge(var.tags, tomap({
    type = "user_assigned_identity"
    })
  ))
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id

  depends_on = [azurerm_container_registry.container_registry, azurerm_user_assigned_identity.user_assigned_identity]
}