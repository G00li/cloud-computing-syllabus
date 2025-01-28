resource "kubernetes_deployment" "postgresql" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgresql"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgresql"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:16"
          port {
            container_port = 5432
          }
          env {
            name  = "POSTGRES_USER"
            value = "odoo"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "odoo_password"
          }
          env {
            name  = "POSTGRES_DB"
            value = "postgres"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgre-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "postgres"
    }
    port {
      port       = 5432
      target_port = 5432
    }
    type = "ClusterIP"
  }
}
