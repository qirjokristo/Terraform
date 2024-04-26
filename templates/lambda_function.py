import boto3

def lambda_handler(event, context):
    # Initialize the EC2 client
    ec2 = boto3.client('ec2')
    
    # Extract instance id from the event
    ${aws_instance.kristo.id} = event['instance_id']
    
    # Terminate the EC2 instance
    response = ec2.terminate_instances(InstanceIds=[${aws_instance.kristo.id}])
    
    # Log the termination response
    print(response)
    
    # Return a response
    return {
        'statusCode': 200,
        'body': 'EC2 instance terminated successfully',
        'instance_id': ${aws_instance.kristo.id}
    }
