variable "namespace" {
  description = "Name of namespace"
  type = string
}

variable "client_name" {
  description = "The name of the client (Netflix, Meta, Rockstar)"
  type        = string
}

variable "environment" {
  description = "The environment (dev, qa, prod)"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the application"
  type        = string
}

variable "replica_number" {
  description = "odoo replica number"
  type        = number
  default     = 1
}

variable "minikube_driver" {
  default = "docker"
}

variable "minikube_cpus" {
  default = 2
}

variable "minikube_memory" {
  default = 4096
}