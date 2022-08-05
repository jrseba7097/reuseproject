package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_policyset_definition(t *testing.T) {

  management_group := "/providers/Microsoft.Management/managementgroups/"
  set := "/providers/Microsoft.Authorization/policySetDefinitions/"
  holder_management_group_name := "CloudTechServ"
  policy_set_name := "bupa-initiative-test"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
		Vars: map[string]interface{}{
			"holder_management_group_name": holder_management_group_name,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack

  test_policyset_id := fmt.Sprintf("%s%s%s%s", management_group, holder_management_group_name, set, policy_set_name)
	output_policyset_id := terraform.Output(t, terraformOptions, "policyset_id")
	assert.Equal(test_policyset_id, output_policyset_id)
}
