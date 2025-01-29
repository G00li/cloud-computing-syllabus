output "odoo_url" {
  description = "odoo app url"
  value       = "http://${kubernetes_service.odoo.metadata[0].name}.${var.namespace}.svc.cluster.local:8069"
}