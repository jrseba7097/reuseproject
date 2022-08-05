locals {
  business_unit  = "cose"
  short_location = "eun"
  rg_name        = "RG-${local.business_unit}-${local.short_location}-SemiTrustTestSpoke"
  nsg_name       = "NSG-${local.business_unit}-${local.short_location}-SemiTrustTestSpoke-Test"

  location = "North Europe"

  tags = {
    "Billing"     = "INSYS-77662"
    "IT Services" = "Azure Cloud Landing Zone"
    "Owner ID"    = ""
    "Project"     = ""
    "Env"         = "Build"
  }
}
