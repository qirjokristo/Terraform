# output "online_azs" {
# value = data.aws_availability_zones.online_azs.names
# }

# output "tags" {
# value = var.common_tags
# }

output "lb_dns" {
  value = aws_lb.kristo.dns_name
}