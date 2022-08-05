locals {
  business_unit  = "cose"
  short_location = "eun"
  rg_name        = "RG-${local.business_unit}-${local.short_location}-SemiTrustTestSpoke"
  location       = "North Europe"

  tags = {
    "Billing"     = "INSYS-77662"
    "IT Services" = "Azure Cloud Landing Zone"
    "Owner ID"    = ""
    "Project"     = ""
    "Env"         = "Build"
  }
}
