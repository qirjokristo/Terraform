
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

#########CONFIGURE VARIABLES##########################

variable "region" {
  type        = string
  description = "The region for the deployment"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "The name of the project"
  default     = "planarian"
}

variable "vpc_cidr" {
  type        = string
  description = "Cidr for vpc"
  default     = "10.233.0.0/16"
}

variable "db_instance_class" {
  type        = string
  description = "The instance class of the database in RDS"
  default     = "db.t3.micro"
}

variable "ec2_instance_class" {
  type        = string
  description = "The instance class of the instance in the Auto Scaling Group"
  default     = "t2.micro"
}