variable "resource_group_name" {
  description = "Location of the resource group."

}

variable "resource_group_location" {
  description = "Location of the resource group."

}
variable "tags" {
  type = map(string)
}

variable "virtual_network_name" {
}

variable "virtual_network_address_space" {
}

variable "subnet_name" {
}

variable "subnet_address_space" {
}
variable "registryName" {

}

