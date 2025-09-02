# terraform/variables.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# variable "vpc_id" {
#   description = "VPC ID for EKS cluster"
#   type        = string
# }

# variable "subnet_ids" {
#   description = "Subnet IDs for EKS cluster"
#   type        = list(string)
# }

variable "backend_image_uri" {
  description = "Docker image URI for backend"
  type        = string
}

variable "frontend_image_uri" {
  description = "Docker image URI for frontend"
  type        = string
}