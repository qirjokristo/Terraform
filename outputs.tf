
output "lb_dns" {
  value = local.website
}

output "lambda_result" {
  value = aws_lambda_invocation.cleanup.result
}