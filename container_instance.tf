
resource "azurerm_container_group" "container_group" {
  name                = var.containerGroupName
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Linux"
  ip_address_type             = "Private"
  subnet_ids                  = [data.azurerm_subnet.subnet.id]

  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  dynamic "container" {
    for_each = var.containers
    content {
      name   = container.value.name
      image  = "${container.value.image}:${var.build_number}"
      cpu    = container.value.cpuCores
      memory = container.value.memoryInGb

      ports {
        port     = container.value.port
        protocol = "TCP"
      }

     secure_environment_variables  = {
        "AZP_URL"        = var.AZP_URL
        "AZP_TOKEN"      = var.AZP_TOKEN
        "AZP_POOL"       = container.value.AZP_POOL
        "AZP_AGENT_NAME" = container.value.AZP_AGENT_NAME
      }

    }
  }

    tags = (merge(var.tags, tomap({
      type = "container_group"
    })
  ))

  image_registry_credential {
    server                    = var.registryLoginServer
    user_assigned_identity_id = data.azurerm_user_assigned_identity.user_assigned_identity.id
  }
 }