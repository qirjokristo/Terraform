# output "online_azs" {
# value = data.aws_availability_zones.online_azs.names
# }

# output "tags" {
# value = var.common_tags
# }

output "lb_dns" {
  value = local.website
}

output "lb_pod" {
  value = data.aws_lb.pod.dns_name
}