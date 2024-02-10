variable "resource_group_name" {
  type = string
}
variable "resource_group_location" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "virtual_network_name" {
  type = string
}

variable "virtual_network_address_space" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_address_space" {
  type = string
}
variable "registryName" {
  type = string
}

variable "containerGroupName" {
  type = string
}

# variable "registryLoginServer" {
#   type = string
# }
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
 