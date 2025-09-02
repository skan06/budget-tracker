#/terraform/main.tf
module "backend" {
  source      = "./modules/backend"
  image_uri   = var.backend_image_uri
}

module "frontend" {
  source      = "./modules/frontend"
  image_uri   = var.frontend_image_uri
}