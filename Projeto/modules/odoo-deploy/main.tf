resource "kubernetes_deployment" "odoo" {
  metadata {
    name      = "odoo"
    namespace = var.namespace
  }

  spec {
    replicas = var.replica_number

    selector {
      match_labels = {
        app = "odoo"
      }
    }

    template {
      metadata {
        labels = {
          app = "odoo"
        }
      }

      spec {
        container {
          name  = "odoo"
          image = "odoo:latest"
          port {
            container_port = 8069
          }

          env {
            name  = "HOST"
            value = "postgres-service"  # Name of the PostgreSQL service
          }

          env {
            name  = "USER"
            value = "odoo"  # PostgreSQL username
          }

          env {
            name  = "PASSWORD"
            value = "odoo"  # PostgreSQL password
          }

          env {
            name  = "DB_NAME"
            value = "odoo"  # PostgreSQL database name
          }

          command = ["/bin/bash", "-c", "odoo -i base --xmlrpc-port=8069"]
        }
      }
    }
  }
}

resource "kubernetes_service" "odoo" {
  metadata {
    name      = "odoo-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "odoo"
    }

    port {
      port        = 80
      target_port = 8069
    }

    type = "ClusterIP"
  }
}