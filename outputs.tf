output "lb_dns" {
  value = local.website
}

output "lb_pod" {
  value = data.aws_lb.pod.dns_name
}