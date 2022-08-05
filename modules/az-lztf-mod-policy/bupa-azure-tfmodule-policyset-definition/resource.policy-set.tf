resource "azurerm_policy_set_definition" "main" {
  name                  = var.name
  policy_type           = var.policy_type
  display_name          = var.display_name
  description           = var.description
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
    {
      "category": "${var.policyset_definition_category}"
    }
METADATA

  parameters = var.parameters

  dynamic "policy_definition_reference" {
    for_each = var.policies
    content {
      policy_definition_id = policy_definition_reference.value["policyID"]
      parameter_values     = policy_definition_reference.value["parameters"]
    }
  }
}
