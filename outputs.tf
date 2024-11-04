# output "online_azs" {
# value = data.aws_availability_zones.online_azs.names
# }

output "lb_dns" {
  value = local.website
}

output "lb_pod" {
  value = data.aws_lb.pod.dns_name
}