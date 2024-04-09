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

variable "files" {
  type        = list(string)
  description = "Files to be uploaded to S3"
  default     = ["files/authentication.php", "files/aws.zip", "files/connection.php", "files/index.html", "files/style.css"]

}