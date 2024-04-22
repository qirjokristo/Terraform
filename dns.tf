data "aws_route53_zone" "website" {
  zone_id = anytrue()
  private_zone = false
}