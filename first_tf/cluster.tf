resource "minikube_cluster" "my-cluster" {
    cluster_name = var.cluster.name
    driver = "docker"
    nodes = var.cluster.nodes
    addons = [
        "ingress"
    ]
}

resource "kubernetes_namespace" "namespace" {
    for_each = toset(var.environment)
  metadata {
    name = each.key
  }
}