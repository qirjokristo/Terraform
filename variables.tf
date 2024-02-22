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