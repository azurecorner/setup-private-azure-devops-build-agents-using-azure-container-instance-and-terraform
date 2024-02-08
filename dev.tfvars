tags = {
  environment = "dev"
  application = "datasynchro"
  deployed_by = "terraform"
}

resource_group_name     = "rg-datasynchro-dev"
resource_group_location = "West Europe"

virtual_network_name          = "vnet-logicapp-demo"
virtual_network_address_space = "10.0.0.0/16"
subnet_name                   = "inboundSubnet"
subnet_address_space          = "10.0.0.0/24"
registryName                  = "lortcslogcorner"
containerGroupName      = "example-container"
registryLoginServer     = "lortcslogcorner.azurecr.io"

containers = [
  {
    name           = "container1"
    image          = "lortcslogcorner.azurecr.io/dockeragent"
    port           = 80
    cpuCores       = 1
    memoryInGb     = 2
    AZP_POOL       = "DOCKER-AGENTS"
    AZP_AGENT_NAME = "DockerBuildAgent01"
  },
  {
    name           = "container2"
    image          = "lortcslogcorner.azurecr.io/dockeragent"
    port           = 82
    cpuCores       = 1
    memoryInGb     = 2
    AZP_POOL       = "DOCKER-AGENTS"
    AZP_AGENT_NAME = "DockerBuildAgent02"
  },
  {
    name           = "container3"
    image          = "lortcslogcorner.azurecr.io/dockeragent"
    port           = 81
    cpuCores       = 1
    memoryInGb     = 2
    AZP_POOL       = "DOCKER-AGENTS"
    AZP_AGENT_NAME = "DockerBuildAgent03"
  }
]
