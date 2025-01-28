
variable "namespace" {
  description = "the namespace of app"
  type        = string
}

variable "client" {
  description = "which client namespace will be used (Netflix, Meta, Rockstar)"
  type        = string
}

variable "environment" {
  description = "which type of env (dev, qa, prod)"
  type        = string
}

variable "domain" {
  description = "The app domain"
  type        = string
}

variable "replica_number" {
  description = "odoo replica number"
  type        = number
  default     = 1
}