package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_Management_group(t *testing.T) {
	display_name := "Test Management Groups"
	name := "TestManagementGroup"
	parent_management_group_id := "/providers/Microsoft.Management/managementGroups/CloudTechServ"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
		Vars: map[string]interface{}{
			"management_groups": map[string]interface{}{
				"name":             name,
				"display_name":     display_name,
				"subscription_ids": []string{},
				"children":         []string{},
			},
			"parent_management_group_id": parent_management_group_id,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	management_group_id := fmt.Sprintf("/providers/Microsoft.Management/managementGroups/%s", name)
	output_management_group_id := terraform.Output(t, terraformOptions, "management_group_id")
	assert.Equal(management_group_id, output_management_group_id)
}
