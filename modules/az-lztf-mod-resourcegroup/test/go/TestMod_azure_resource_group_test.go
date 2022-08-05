// install golang

// export GOPATH=~/Documents/aaa/automated_testing/go_test
// cd $GOPATH
// mkdir src
// mkdir auto_test

// cd ./src/auto_test

// dep init
// dep ensure

// go test -v -run Test_TerraformExample
// go test -v

// look at this: https://docs.microsoft.com/en-us/azure/developer/terraform/test-modules-using-terratest#integration-test
package test

import (
	"fmt"
	"math/rand"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_TerraformExample(t *testing.T) {
	rand.Seed(time.Now().UnixNano())
	uniqueID := rand.Intn(100)
	name := fmt.Sprintf("rg-shared-terratest-test-0%v", uniqueID)
	location := "eastus"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
		Vars: map[string]interface{}{
			"name":     name,
			"location": location,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	// test stack
	resource_group_name := fmt.Sprintf("%s", name)
	output_resource_group_name := terraform.Output(t, terraformOptions, "resource_group_name")
	assert.Equal(resource_group_name, output_resource_group_name)
}
