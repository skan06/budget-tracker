// terraform_test.go
package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBudgetTrackerInfra(t *testing.T) {
	// Define Terraform options
	terraformOptions := &terraform.Options{
		// Path to your Terraform code
		TerraformDir: "../../terraform",

		// Variables to pass (must match your terraform.tfvars)
		Vars: map[string]interface{}{
			"backend_image_uri":  "654654557455.dkr.ecr.us-east-1.amazonaws.com/budget-tracker-backend:latest",
			"frontend_image_uri": "654654557455.dkr.ecr.us-east-1.amazonaws.com/budget-tracker-frontend:latest",
		},

		// Use the same backend config
		NoColor: true,
	}

	// Clean up after test (optional: comment out if you want to keep infra)
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform
	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	clusterName := terraform.Output(t, terraformOptions, "cluster_name")
	frontendURL := terraform.Output(t, terraformOptions, "frontend_app_url")
	backendRepo := terraform.Output(t, terraformOptions, "backend_repo_url")

	// Run assertions
	assert.Equal(t, "budget-tracker-eks", clusterName)
	assert.Contains(t, backendRepo, "654654557455.dkr.ecr.us-east-1.amazonaws.com")
	assert.Contains(t, frontendURL, "elb.amazonaws.com")
}