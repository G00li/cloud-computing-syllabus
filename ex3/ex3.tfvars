namespaces = ["dev", "qa", "prod"]

odoo = {
  name              = "odoo"
  containerName     = "odoo"
  image             = "odoo:16.0"
  port              = 8069
  replicas          = {
    dev  = 1
    qa   = 2
    prod = 3
  }
  database_image    = "postgres:13"
  database_name     = "odoo_db"
  database_user     = "odoo_user"
  database_password = "odoo_pass"
  database_port     = 5432
}
