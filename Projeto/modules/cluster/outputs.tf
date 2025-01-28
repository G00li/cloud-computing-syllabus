output "role_name" {
  description = "The name of the created Role"
  value       = kubernetes_role.odoo_role.metadata[0].name
}

output "role_binding_name" {
  description = "The name of the created RoleBinding"
  value       = kubernetes_role_binding.odoo_role_binding.metadata[0].name
}