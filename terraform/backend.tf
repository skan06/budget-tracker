# terraform/backend.tf
terraform {
  backend "s3" {
    bucket = "task-manager-terraform-state-sk06h"  # ← Use this bucket
    key    = "budget-tracker/terraform.tfstate"
    region = "us-east-1"
  }
}