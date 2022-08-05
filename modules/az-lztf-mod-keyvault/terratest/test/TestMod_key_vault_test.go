package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMod_Key_Vault(t *testing.T) {

	key_vault_name := "KV-test-kv457"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example/",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert := assert.New(t)

	test_name := fmt.Sprintf("%s", key_vault_name)
	output_name := terraform.Output(t, terraformOptions, "name")
	assert.Equal(test_name, output_name)
}
