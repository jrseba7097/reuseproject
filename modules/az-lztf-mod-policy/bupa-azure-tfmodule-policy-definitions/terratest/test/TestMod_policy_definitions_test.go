package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_policy_definitions(t *testing.T) {
  management_group := "/providers/Microsoft.Management/managementgroups/"
  holder_management_group_name := "CloudTechServ"
  definition := "/providers/Microsoft.Authorization/policyDefinitions/"
  tag := "ENV"

  allowedlocations_policy_name := "bupa-allowed-locations"
  audit_subnet_without_nsg_policy_name := "bupa-audit-SubnetWithoutNSG"
  deny_publicip_spoke_policy_name := "bupa-deny-publicip-creation"
  deny_publicips_on_nics_policy_name := "bupa-deny-publicips-on-nics"
  tag_add_name := "bupa-add-TagToRG_ENV"
  tag_inherit_name := "bupa-inherit-TagFromRG_ENV"
  tag_inherit_overwrite_name := "bupa-inherit-TagFromRG_ENV_OverwriteExisting"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
		Vars: map[string]interface{}{
			"holder_management_group_name": holder_management_group_name,
			"mandatory_tag_keys": []string{tag},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack

  test_allowedlocations_policy_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, definition, allowedlocations_policy_name)
	output_allowedlocations_policy_id := terraform.Output(t, terraformOptions, "allowedlocations_policy_id")
	assert.Equal(test_allowedlocations_policy_id, output_allowedlocations_policy_id)

  test_audit_subnet_without_nsg_policy_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, definition, audit_subnet_without_nsg_policy_name)
	output_audit_subnet_without_nsg_policy_id := terraform.Output(t, terraformOptions, "audit_subnet_without_nsg_policy_id")
	assert.Equal(test_audit_subnet_without_nsg_policy_id, output_audit_subnet_without_nsg_policy_id)

  test_deny_publicip_spoke_policy_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, definition, deny_publicip_spoke_policy_name)
	output_deny_publicip_spoke_policy_id := terraform.Output(t, terraformOptions, "deny_publicip_spoke_policy_id")
	assert.Equal(test_deny_publicip_spoke_policy_id, output_deny_publicip_spoke_policy_id)

  test_deny_publicips_on_nics_policy_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, definition, deny_publicips_on_nics_policy_name)
	output_deny_publicips_on_nics_policy_id := terraform.Output(t, terraformOptions, "deny_publicips_on_nics_policy_id")
	assert.Equal(test_deny_publicips_on_nics_policy_id, output_deny_publicips_on_nics_policy_id)

	test_tag_add_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, definition, tag_add_name)
	output_tag_add_ids := terraform.OutputList(t, terraformOptions, "addTagToRG_policy_ids")
	assert.Equal(test_tag_add_id, output_tag_add_ids[0])

	test_tag_inherit_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, definition, tag_inherit_name)
	output_tag_inherit_ids := terraform.OutputList(t, terraformOptions, "inheritTagFromRG_policy_ids")
	assert.Equal(test_tag_inherit_id, output_tag_inherit_ids[0])

  test_tag_inherit_overwrite_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, definition, tag_inherit_overwrite_name)
	output_tag_inherit_overwrite_ids := terraform.OutputList(t, terraformOptions, "inheritTagFromRGOverwriteExisting_policy_ids")
	assert.Equal(test_tag_inherit_overwrite_id, output_tag_inherit_overwrite_ids[0])
}
