package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_NSG(t *testing.T) {
	name := "NSG-cose-eun-SemiTrustTestSpoke-Test"
	rule_name := "HTTPS-to-Test"
	rule_port := "443"
	rule_priority := 100

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	test_name := fmt.Sprintf("%s", name)
	output_name := terraform.Output(t, terraformOptions, "name")
	assert.Equal(test_name, output_name)

	test_rule_name := fmt.Sprintf("%s", rule_name)
	output_rules := terraform.OutputListOfObjects(t, terraformOptions, "rules")
	assert.Equal(test_rule_name, output_rules[0]["name"])

	test_rule_port := fmt.Sprintf("%s", rule_port)
	assert.Equal(test_rule_port, output_rules[0]["destination_port_range"])

	test_rule_priority := rule_priority
	assert.Equal(test_rule_priority, output_rules[0]["priority"].(int))
}
