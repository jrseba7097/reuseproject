package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)


func TestMod_Policy_Assign(t *testing.T) {

  scope := "/providers/Microsoft.Management/managementGroups/CloudTechServ"
  governance_name := "Security_Governance"
  policy_definition_id := "/providers/Microsoft.Authorization/policyDefinitions/b5ec538c-daa0-4006-8596-35468b9148e8"


  terraformOptions := &terraform.Options{
  	TerraformDir: "../example/",
  }

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	name := fmt.Sprintf("%s", governance_name)
	output_name := terraform.Output(t, terraformOptions, "name")
	assert.Equal(name, output_name)

	security_govern_id := fmt.Sprintf("%s", policy_definition_id)
	security_output_name := terraform.Output(t, terraformOptions, "policy_definition_id")
	assert.Equal(security_govern_id, security_output_name)

	scope_id := fmt.Sprintf("%s", scope)
	output_scope_id := terraform.Output(t, terraformOptions, "scope")
	assert.Equal(scope_id, output_scope_id)
}
