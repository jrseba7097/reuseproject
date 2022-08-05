variable "location" {
  description = "The full (Azure) location identifier for the firewall"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group to deploy the firewall to"
  type        = string
}

variable "enable" {
  description = "Deploy Firewall true/false"
  type        = string
}

variable "firewall_name" {
  description = "Name to deploy firewall with"
  type        = string
}

variable "zones" {
  description = "Specifies the availability zones in which the Azure Firewall should be created. Changing this forces a new resource to be created"
  type        = list(any)
  default     = [1, 2, 3, ]
}

variable "subnet_id" {
  description = "Subnet Id to deploy firewall in"
  type        = string
}

variable "firewall_pip_name" {
  description = "Name to deploy firewall public ip with"
  type        = string
}

variable "fw_threat_intel_mode" {
  description = "The firewall operation mode for threat intelligence-based filtering. Possible values are: Off, Alert and Deny. Defaults to Alert"
  type        = string
  default     = "Alert"
}

variable "firewall_policy_id" {
  description = "The ID of the Firewall Policy applied to this Firewall"
  type        = string
  default     = ""
}

variable "sku_name" {
  description = "Sku name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created"
  type        = string
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  description = "Sku tier of the Firewall. Possible values are Premium and Standard. Changing this forces a new resource to be created"
  type        = string
  default     = "Standard"
}

variable "enable_logs" {
  description = "Deploy diagnostic settings true/false"
  type        = string
  default     = "true"
}

variable "storage_account_id" {
  type        = string
  description = "Storage account id to log the events to"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace ID to use for the logs"
}

variable "retention_days" {
  type        = number
  description = "The number of days for which this Retention Policy should apply"
  default     = 365
}

variable "policy_name" {
  description = "Name to deploy policy with"
  type        = string
}

variable "fw_network_rules" {
  type        = list(any)
  description = "List that manages Network Rule Collections within an Azure Firewall Policy"
  default     = []
}

variable "fw_network_fqdns_rules" {
  type        = list(any)
  description = "List that manages FQDNS Network Rule Collections within an Azure Firewall Policy"
  default     = []
}

variable "fw_application_rules" {
  type        = list(any)
  description = "List that manages Application Rule Collections within an Azure Firewall Policy"
  default     = []
}

variable "fw_nat_rules" {
  type        = list(any)
  description = "List that manages Nat Rule Collections within an Azure Firewall Policy"
  default     = []
}

variable "dns_servers" {
  type        = list(any)
  description = "A list of custom DNS servers' IP addresses"
  default     = []
}

variable "proxy_enabled" {
  type        = bool
  description = "Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false"
  default     = false
}

variable "extra_public_ips" {
  type        = list(string)
  description = "Names of extra public ips to associate to the firewall"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to assign the module components"
  default     = {}
}
