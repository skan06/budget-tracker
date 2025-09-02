# terraform/eks.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = "budget-tracker-eks"
  cluster_version = "1.30"

  # ✅ Use VPC from module
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # For worker nodes to access internet
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    min_size     = 1
    max_size     = 3
    desired_size = 2
  }

  eks_managed_node_groups = {
    ng1 = {}
  }

  enable_irsa = true
}