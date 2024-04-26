resource "aws_lambda_function" "cleanup" {
  function_name = "kristo_cleanup"
  role          = aws_iam_role.lambda.arn
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"

}