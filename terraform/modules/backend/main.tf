# terraform/modules/backend/main.tf
variable "image_uri" {
  description = "Docker image URI for the backend"
  type        = string
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "backend" }
    }
    template {
      metadata {
        labels = { app = "backend" }
      }
      spec {
        container {
          name  = "backend"
          image = var.image_uri
          port {
            container_port = 8081
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name = "backend-service"
  }
  spec {
    selector = { app = "backend" }
    port {
      port        = 8081
      target_port = 8081
    }
    type = "ClusterIP"
  }
}