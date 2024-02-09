variable "resource_group_name" {
  description = "Location of the resource group."

}

variable "resource_group_location" {
  description = "Location of the resource group."

}
variable "tags" {
  type = map(string)
}


variable "containerGroupName" {

}

variable "registryLoginServer" {

}
variable "AZP_URL" {
  type = string
}

variable "AZP_TOKEN" {
  type = string
}
variable "build_number" {
  type = string
}

variable "containers" {
  type = list(object({
    name           = string
    image          = string
    port           = number
    cpuCores       = number
    memoryInGb     = number
    AZP_POOL       = string
    AZP_AGENT_NAME = string
  }))

}
 