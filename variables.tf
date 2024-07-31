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