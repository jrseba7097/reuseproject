package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureLogAnalytics(t *testing.T) {

	workspace_name := "LOGAW-cose-eun-terratest"
	resource_group_name := "RG-cose-eun-test"
	location := "northeurope"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	test_name := fmt.Sprintf("%s", workspace_name)
	output_name := terraform.Output(t, terraformOptions, "workspace_name")
	assert.Equal(test_name, output_name)

	test_resource_group := fmt.Sprintf("%s", resource_group_name)
	output_resource_group := terraform.Output(t, terraformOptions, "resource_group_name")
	assert.Equal(test_resource_group, output_resource_group)

	test_location := fmt.Sprintf("%s", location)
	output_location := terraform.Output(t, terraformOptions, "location")
	assert.Equal(test_location, output_location)
}
