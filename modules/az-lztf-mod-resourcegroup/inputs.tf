
variable "name" {
  type        = string
  description = "Resource Group name"
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to assign the module components"
  default     = {}
}


variable "location" {
  description = "The full (Azure) location identifier for the Resource Group"
  type        = string
}
