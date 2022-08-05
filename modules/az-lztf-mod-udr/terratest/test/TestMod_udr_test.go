package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_UDR(t *testing.T) {
	name := "RT-cose-eun-SemiTrustTestSpoke-Test"
	route_name := "ROUTE-Default"
	address_prefix := "0.0.0.0/0"
	next_hop_type := "VirtualAppliance"
    next_hop_in_ip_address := "192.168.0.0"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
		Vars: map[string]interface{}{
			"udr_routes": []map[string]interface{}{
				{
					"name"              	 : route_name,
					"address_prefix"  		 : address_prefix,
					"next_hop_type" 		 : next_hop_type,
					"next_hop_in_ip_address" : next_hop_in_ip_address,
				},
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	test_name := fmt.Sprintf("%s", name)
	output_name := terraform.Output(t, terraformOptions, "name")
	assert.Equal(test_name, output_name)

	test_route_name := fmt.Sprintf("%s", route_name)
	output_routes := terraform.OutputListOfObjects(t, terraformOptions, "routes")
	assert.Equal(test_route_name, output_routes[0]["name"])

	test_next_hop := fmt.Sprintf("%s", next_hop_in_ip_address)
	assert.Equal(test_next_hop, output_routes[0]["next_hop_in_ip_address"])
}
