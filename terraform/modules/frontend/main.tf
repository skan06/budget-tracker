# terraform/modules/frontend/main.tf
variable "image_uri" {
  description = "Docker image URI for the frontend"
  type        = string
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "frontend" }
    }
    template {
      metadata {
        labels = { app = "frontend" }
      }
      spec {
        container {
          name  = "frontend"
          image = var.image_uri
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend-service"
  }
  spec {
    selector = { app = "frontend" }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}