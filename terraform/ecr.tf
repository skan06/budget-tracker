# terraform/ecr.tf
resource "aws_ecr_repository" "backend" {
  name = "budget-tracker-backend"
  force_delete = true
}

resource "aws_ecr_repository" "frontend" {
  name = "budget-tracker-frontend"
  force_delete = true
}
