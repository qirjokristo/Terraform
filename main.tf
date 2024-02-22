provider "aws" {
  access_key = "AKIARP4IYPMNCWUEKFWM"
  secret_key = "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"
  region     = "us-east-1"
}

data "aws_availability_zones" "online_azs" {
  state = "available"

}