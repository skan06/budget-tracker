# terraform/postgres.tf
# PostgreSQL Secret
resource "kubernetes_secret" "db_secret" {
  metadata {
    name = "db-secret"
  }

  data = {
    postgres-password = "your-secure-password-here"  # Change this
  }

  type = "Opaque"
}

# PostgreSQL StatefulSet
resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    service_name = "postgres-service"
    replicas = 1

    selector {
      match_labels = { app = "postgres" }
    }

    template {
      metadata {
        labels = { app = "postgres" }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:17.5"

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = "postgres"
          }

          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "db-secret"
                key  = "postgres-password"
              }
            }
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "postgres-storage"

          persistent_volume_claim {
            claim_name = "postgres-claim"
          }
        }
      }
    }
  }
}

# PostgreSQL Service
resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres-service"
  }

  spec {
    selector = { app = "postgres" }
    port {
      port        = 5432
      target_port = 5432
    }
    type = "ClusterIP"
  }
}

# Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "postgres" {
  metadata {
    name = "postgres-claim"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}