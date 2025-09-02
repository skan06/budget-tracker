provider "aws" {
  region = "us-east-1" # Region for state management resources
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "task-manager-terraform-state-sk06h" # Unique bucket name
  force_destroy = true
  tags = {
    Name = "TerraformStateBucket" # Tag for identification
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled" # Enable versioning to keep state history
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks" # Table name
  billing_mode = "PAY_PER_REQUEST" # On-demand billing (free tier eligible)
  hash_key     = "LockID"         # Primary key for locking
  attribute {
    name = "LockID"               # Attribute name
    type = "S"                    # String type
  }
  tags = {
    Name = "TerraformLocksTable" # Tag for identification
  }
}