output "postgres_service_name" {
  description = "name of postgres service"
  value       = kubernetes_service.postgres.metadata[0].name
}