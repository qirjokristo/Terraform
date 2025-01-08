variable "cidr_all" {
  type        = string
  description = "Cidr for all ips"
  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type        = string
  description = "Cidr for vpc"
  default     = "10.233.0.0/16"
}

variable "region" {
  type        = string
  description = "Region to be deployed to"
  default     = "us-east-1"
}

variable "db_user" {
  sensitive   = true
  description = "Database master username credentials"
  type        = string
  default     = "admin"

}

variable "project" {
  type        = string
  description = "The name of the project"
  default     = "panamax"
}