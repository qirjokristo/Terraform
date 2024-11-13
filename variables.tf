variable "common_tags" {
  type = object({
    author      = string
    environment = string
    project     = string
  })
  description = "Tags to be used in commonly"
  default = {
    author      = "Kristo"
    environment = "Sandbox"
    project     = "Panamax"
  }
}

variable "kube_tags" {
  type = object({
    author      = string
    environment = string
    project     = string
  })
  description = "Tags to be for kubernetes"
  default = {
    author      = "Kristo"
    environment = "Sandbox"
    project     = "Panamax"
  }
}

variable "vpc_cidr" {
  type        = string
  description = "Cidr for vpc"
  default     = "10.233.0.0/16"
}

variable "cidr_all" {
  type        = string
  description = "Cidr for all ips"
  default     = "0.0.0.0/0"
}

variable "db_user" {
  sensitive   = true
  description = "Database master username credentials"
  type        = string
  default     = "admin"

}

variable "region" {
  type        = string
  description = "Region to be deployed to"
  default     = "us-east-1"
}

variable "project" {
  type = string
  description = "The name of the project"
  default = "panamax"
}