provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "client_namespace" {
  metadata {
    name = "${var.client}-${var.environment}"
  }
}

module "kubernetes_cluster" {
  source     = "./modules/cluster"
  namespace  = kubernetes_namespace.client_namespace.metadata[0].name
}

module "postgresql" {
  source     = "./modules/postgres"
  namespace  = kubernetes_namespace.client_namespace.metadata[0].name
}

module "odoo_deployment" {
  source       = "./modules/odoo-deploy"
  namespace    = kubernetes_namespace.client_namespace.metadata[0].name
  replica_number = var.replica_number
}

module "ingress" {
  source     = "./modules/ingress"
  domain = var.domain
  namespace  = kubernetes_namespace.client_namespace.metadata[0].name
}