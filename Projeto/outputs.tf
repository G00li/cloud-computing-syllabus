output "ingress_url" {
  description = "app url"
  value       = module.ingress.ingress_url
}

output "namespace" {
  description = "app namespace"
  value       = kubernetes_namespace.client_namespace.metadata[0].name
}