terraform {
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "0.4.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
  }
}

provider "minikube" {}

provider "kubernetes" {
  host                   = "https://192.168.67.2:8443" # URL do servidor do cluster
  client_certificate     = file("/home/vscode/.minikube/profiles/ex2/client.crt") # Caminho do certificado do cliente
  client_key             = file("/home/vscode/.minikube/profiles/ex2/client.key") # Caminho da chave do cliente
  cluster_ca_certificate = file("/home/vscode/.minikube/ca.crt") # Caminho do CA do cluster
}


variable "namespaces" {
  type        = list(string)
  description = "Kubernetes Namespaces"
  nullable    = false
}

variable "odoo" {
  type = object({
    name              = string
    containerName     = string
    image             = string
    replicas          = map(number)
    port              = number
    database_image    = string
    database_name     = string
    database_user     = string
    database_password = string
    database_port     = number
  })
}

resource "minikube_cluster" "cluster" {
  cluster_name = "odoo-cluster"
  nodes        = 1
}

resource "kubernetes_namespace" "environment" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.key
  }
}

# PostgreSQL Deployment
resource "kubernetes_deployment" "database" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "postgresql-${each.key}"
    namespace = each.key
    labels = {
      app = "postgresql-${each.key}"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgresql-${each.key}"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgresql-${each.key}"
        }
      }
      spec {
        container {
          image = var.odoo.database_image
          name  = "postgresql"
          env {
            name  = "POSTGRES_DB"
            value = var.odoo.database_name
          }
          env {
            name  = "POSTGRES_USER"
            value = var.odoo.database_user
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.odoo.database_password
          }
          port {
            container_port = var.odoo.database_port
          }
        }
      }
    }
  }
}

# PostgreSQL Service
resource "kubernetes_service" "database" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "postgresql-service-${each.key}"
    namespace = each.key
  }
  spec {
    selector = {
      app = "postgresql-${each.key}"
    }
    port {
      protocol    = "TCP"
      port        = var.odoo.database_port
      target_port = var.odoo.database_port
    }
    type = "ClusterIP"
  }
}

# Odoo Deployment
resource "kubernetes_deployment" "odoo" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "${var.odoo.name}-${each.key}"
    namespace = each.key
    labels = {
      app = "${var.odoo.name}-${each.key}"
    }
  }
  spec {
    replicas = var.odoo.replicas[each.key]
    selector {
      match_labels = {
        app = "${var.odoo.name}-${each.key}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${var.odoo.name}-${each.key}"
        }
      }
      spec {
        container {
          image = var.odoo.image
          name  = var.odoo.containerName
          env {
            name  = "HOST"
            value = "postgresql-service-${each.key}"
          }
          env {
            name  = "USER"
            value = var.odoo.database_user
          }
          env {
            name  = "PASSWORD"
            value = var.odoo.database_password
          }
          env {
            name  = "DBNAME"
            value = var.odoo.database_name
          }
          port {
            container_port = var.odoo.port
          }
        }
      }
    }
  }
}

# Odoo Service
resource "kubernetes_service" "odoo" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "${var.odoo.name}-service-${each.key}"
    namespace = each.key
  }
  spec {
    selector = {
      app = "${var.odoo.name}-${each.key}"
    }
    port {
      protocol    = "TCP"
      port        = var.odoo.port
      target_port = var.odoo.port
    }
    type = each.key == "prod" ? "LoadBalancer" : "ClusterIP"
  }
}

resource "kubernetes_ingress" "prod_tls" {
  depends_on = [kubernetes_service.odoo]
  for_each   = toset(var.namespaces)

  metadata {
    name      = "ingress-${each.key}"
    namespace = each.key
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
    }
  }

  spec {
    rule {
      host = each.key == "prod" ? "odoo.example.com" : null
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.odoo[each.key].metadata[0].name
            service_port = var.odoo.port
          }
        }
      }
    }

    tls {
      secret_name = "tls-secret-${each.key}"
      hosts       = each.key == "prod" ? ["odoo.example.com"] : []
    }
  }
}
