resource "kubernetes_ingress_v1" "odoo_https" {
  metadata {
    name = "odoo-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }

  }
  spec {
    rule {
      host = var.domain
      http {
        path {
          path = "/"
          path_type = "Prefix"
          
          backend {
            service {
              name = "odoo-service"
            port {
              number = 80 
            }
            }
          }
        }
      }
    }
  }
}