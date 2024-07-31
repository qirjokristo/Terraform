# terraform {
#   backend "s3" {
#     bucket = aws_s3_bucket.kristo.name
#     key    = "state/"
#     region = "us-east-1"
#   }
# }

provider "aws" {
  region = "us-east-1"
}

provider "random" {

}
provider "time" {

}