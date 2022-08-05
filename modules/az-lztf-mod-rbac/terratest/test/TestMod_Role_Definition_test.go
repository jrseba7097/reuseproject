package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_Role_Definition(t *testing.T) {
	name := "Custom role definition - test"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	test_name := fmt.Sprintf("%s", name)
	output_assignments := terraform.OutputListOfObjects(t, terraformOptions, "custom_roles")
	assert.Equal(test_role, output_assignments[0]["name"])
}
