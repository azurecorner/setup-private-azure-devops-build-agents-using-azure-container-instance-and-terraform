resource "azurerm_resource_group" "resource_group" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "virtual_network" {
  address_space       = [var.virtual_network_address_space]
  location            = var.resource_group_location
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.resource_group,
  ]
}

resource "azurerm_subnet" "devops_subnet" {
  address_prefixes     = [var.subnet_address_space]
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  service_endpoints    = ["Microsoft.Storage"]
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  delegation {
    name = "delegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.ContainerInstance/containerGroups"
    }
  }
  depends_on = [
    azurerm_virtual_network.virtual_network
  ]
}

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "${var.resource_group_name}-identity"

  tags = (merge(var.tags, tomap({
    type = "user_assigned_identity"
    })
  ))
  depends_on = [azurerm_resource_group.resource_group]
}

module "container_registry" {
  source                              = "./modules/container_registry"
  resource_group_name                 = var.resource_group_name
  resource_group_location             = var.resource_group_location
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.user_assigned_identity.principal_id
  registryName                        = var.registryName
  tags = (merge(var.tags, tomap({
    type = "container_registry"
    })
  ))
  depends_on = [azurerm_resource_group.resource_group]
}

module "container_instance" {
  source                    = "./modules/container_instance"
  resource_group_name       = var.resource_group_name
  resource_group_location   = var.resource_group_location
  containerGroupName        = var.containerGroupName
  build_number              = var.build_number
  registryLoginServer       = module.container_registry.container_registryç_login_server
  AZP_URL                   = var.AZP_URL
  AZP_TOKEN                 = var.AZP_TOKEN
  containers                = var.containers
  user_assigned_identity_id = azurerm_user_assigned_identity.user_assigned_identity.id
  subnetId                  = azurerm_subnet.devops_subnet.id
  tags = (merge(var.tags, tomap({
    type = "container_instance"
    })
  ))
  depends_on = [azurerm_resource_group.resource_group]
}