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
    project     = "Terraform Infrastructure Learning"
  }

}

variable "cidr_all" {
  type        = string
  description = "Cidr for all ips"
  default     = "0.0.0.0/0"
}

variable "db_tmp_cred" {
  sensitive   = true
  description = "Database master credentials"
  type = object({
    username = string
    password = string
  })
  default = {
    username = "admin"
    password = "admin"
  }
}
