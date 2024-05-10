data "archive_file" "zip" {
  depends_on       = [aws_instance.kristo]
  type             = "zip"
  output_file_mode = "0666"
  source {
    content  = <<EOF
import boto3

def lambda_handler(event, context):
    instance_id = '${aws_instance.kristo.id}'
    
    ec2_client = boto3.client('ec2')
    response = ec2_client.terminate_instances(InstanceIds=[instance_id])
    
    return {
        'statusCode': 200,
        'body': "Instance {instance_id} terminated successfully."
    }
EOF
    filename = "lambda_function.py"
  }
  output_path = "${path.module}/templates/cleanup.zip"
}



resource "aws_lambda_function" "cleanup" {
  function_name = "kristo_cleanup"
  role          = aws_iam_role.lambda.arn
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  filename      = "${path.module}/templates/cleanup.zip"
  depends_on    = [aws_ami_from_instance.kristo]
  timeout       = 30
}

resource "aws_lambda_invocation" "cleanup" {
  function_name = aws_lambda_function.cleanup.function_name
  input = jsonencode({
    "key1" : "valueB",
    "key2" : "value2",
  })
}