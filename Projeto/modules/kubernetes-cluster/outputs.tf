output "role_name" {
  description = "The name of the Kubernetes Role created for Odoo"
  value       = kubernetes_role.odoo_role.metadata[0].name
}

output "role_binding_name" {
  description = "The name of the Kubernetes RoleBinding created for Odoo"
  value       = kubernetes_role_binding.odoo_role_binding.metadata[0].name
}