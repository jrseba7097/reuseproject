package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_Role_Assignment(t *testing.T) {
	role := "Reader"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	test_role := fmt.Sprintf("%s", role)
	output_assignments := terraform.OutputListOfObjects(t, terraformOptions, "assignments")
	assert.Equal(test_role, output_assignments[0]["role_definition_name"])
}
