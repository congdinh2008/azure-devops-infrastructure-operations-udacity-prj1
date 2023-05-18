# Common Variables

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group in which the resources will be created"
  default     = "Azuredevops"
}

# Azure region
variable "location" {
  type        = string
  description = "Location where resources will be created"
  default     = "southeastasia"
}

variable "tags" {
  description = "Map of the tags to use for the resources that are deployed"
  type        = map(string)
  default = {
    create-by = "congdinh2023"
  }
}

# Packer resources
variable "packer_resource_group_name" {
  type        = string
  description = "Name of the resource group in which the Packer image will be created"
  default     = "Azuredevops"
}

variable "packer_image_name" {
  type        = string
  description = "Name of the Packer image"
  default     = "udacity-ubuntu-server-image"
}

variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in the resource group specified"
  default     = "udacity-project1"
}

# Project Environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "development"
}


# Azure Authentication variables

variable "azure-subscription-id" {
  type        = string
  description = "Azure Subscription Id"
}

variable "azure-client-id" {
  type        = string
  description = "Azure Client Id"
}

variable "azure-client-secret" {
  type        = string
  description = "Azure Client Secret"
}

variable "azure-tenant-id" {
  type        = string
  description = "Azure Tenant Id"
}

variable "network-interfaces-count" {
  type        = number
  description = "Number of interfaces"
  default     = 2
}

# Virtual Machine variables

# Virtual Machine Admin User
variable "admin-user" {
  type        = string
  description = "Virtual Machine Admin User"
  default     = "congdinh2023"
}

# Virtual Machine Admin Password
variable "admin-password" {
  type        = string
  description = "Virtual Machine Admin Password"
}

# Virtual Machine Size
variable "vm-size" {
  type        = string
  description = "VM Size"
  default     = "Standard_B1s"
}

# Load balancer vms number
variable "num_of_vms" {
  description = "Number of VM resources to create behind the load balancer"
  default     = 2
  type        = number
}
