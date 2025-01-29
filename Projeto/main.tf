provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "client_namespace" {
  metadata {
    name = "${var.client_name}-${var.environment}"
  }
}

resource "null_resource" "minikube_profile" {
  provisioner "local-exec" {
    command = <<EOT
    if ! minikube profile list | grep -q "${var.client_name}"; then
      minikube start --profile=${var.client_name} \
        --driver=${var.minikube_driver} \
        --cpus=${var.minikube_cpus} \
        --memory=${var.minikube_memory}
    else
      echo "Minikube profile '${var.client_name}' already exists."
    fi

    kubectl config use-context ${var.client_name}
    kubectl config set-context --current --namespace=${var.client_name}-${var.environment}
    EOT
  }
}

module "kubernetes_cluster" {
  source     = "./modules/kubernetes-cluster"
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
  domain = var.domain_name
  namespace  = kubernetes_namespace.client_namespace.metadata[0].name
}
