# terraform {
#   backend "s3" {
#     bucket = "kristo-tfstates-UPDATE"
#     key = "/state/master.tfstate"
#     region = "us-east-1"
#   }
# }

provider "aws" {
  region = var.region
}

provider "random" {

}
provider "time" {

}