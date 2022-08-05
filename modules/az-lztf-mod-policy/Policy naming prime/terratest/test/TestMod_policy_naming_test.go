package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)


func TestMod_Policy_Naming(t *testing.T) {

  name := "bupaNaming"

  terraformOptions := &terraform.Options{
  	TerraformDir: "../example/",
  }

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	assignment_name := fmt.Sprintf("%s", name)
	assignment_name_output := terraform.Output(t, terraformOptions, "policy_set_assignment_name")
	assert.Equal(assignment_name, assignment_name_output)

  definition_name := fmt.Sprintf("%s", name)
	definition_name_output := terraform.Output(t, terraformOptions, "policy_set_definition_name")
	assert.Equal(definition_name, definition_name_output)
}
