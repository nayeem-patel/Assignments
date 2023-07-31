variable "resource_group_name" {
  type        = string
  description = "Eneter name of Azure resource group"
  validation {
    condition     = length(var.resource_group_name) >= 3 && length(var.resource_group_name) <= 64
    error_message = "Resource group name should be greater than or equal To (>=) 3 and less than or equal To <= 64"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.resource_group_name))
    error_message = "Resource group name is not valid, value should be A-Z or a-z or 0-9"
  }
}
variable "resource_location" {
  default     = "eastus"
  type        = string
  description = "Resource location"
}
