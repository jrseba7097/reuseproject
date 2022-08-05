package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_VNET(t *testing.T) {
	name := "VNET-cose-eun-SemiTrustTestSpoke"
	address_space := "192.168.1.0/24"
	ddos_protection_plan_id := ""
	subnet_name := "SNET-cose-eun-SemiTrustTestSpoke-Test"
	subnet_address_space := "192.168.1.0/24"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
		Vars: map[string]interface{}{
			"vnet": map[string]interface{}{
				"name": name,
				"address_spaces": []string{address_space},
				"dns_servers": []string{},
				"ddos_protection_plan_id": ddos_protection_plan_id,
				"subnets": []map[string]interface{}{
					{
						"name"              : subnet_name,
						"address_prefixes"  : []string{subnet_address_space},
						"service_endpoints" : []string{},
					},
				},
				"peerings": []string{},
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	test_name := fmt.Sprintf("%s", name)
	output_name := terraform.Output(t, terraformOptions, "vnet_name")
	assert.Equal(test_name, output_name)

	test_address_space := fmt.Sprintf("[%s]", address_space)
	output_address_space := terraform.Output(t, terraformOptions, "address_space")
	assert.Equal(test_address_space, output_address_space)

	test_subnet_name := fmt.Sprintf("%s", subnet_name)
	output_subnet_ids := terraform.Output(t, terraformOptions, "subnet_ids")
	assert.Contains(output_subnet_ids, test_subnet_name)
}
