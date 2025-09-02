# terraform/vpc.tf
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13"  # ← This is the correct version
  # If it still fails, try commenting out 'version' temporarily
  # version = "6.0.1"

  name = "budget-tracker-vpc"
  cidr = "10.100.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.100.1.0/24", "10.100.2.0/24"]
  public_subnets  = ["10.100.101.0/24", "10.100.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "budget-tracker"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}