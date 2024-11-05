<?php

 

require 'aws-autoloader.php';
use Aws\SecretsManager\SecretsManagerClient;
use Aws\Exception\AwsException;

 

$client = new SecretsManagerClient([
    'region' => 'us-east-1',
]);

 

$secretName = 'panamax-secret';

 

try {
    $result = $client->getSecretValue([
        'SecretId' => $secretName,  
    ]);
} catch (AwsException $e) {
    $error = $e->getAwsErrorCode();
    if ($error == 'DecryptionFailureException') {
        throw $e;
    }
    if ($error == 'InternalServiceErrorException') {
        throw $e;
    }
    if ($error == 'InvalidParameterException') {
        throw $e;
    }
    if ($error == 'InvalidRequestException') {
        throw $e;
    }
    if ($error == 'ResourceNotFoundException') {
        throw $e;
    }
}

 

if (isset($result['SecretString'])) {
    $secret = $result['SecretString'];
} else {
    $secret = base64_decode($result['SecretBinary']);
}

 
$secretArray = json_decode($secret, true);
$user = $secretArray['username'];
$password = $secretArray['password'];
$host = $secretArray['host'];
$db_name = "project";

 

$con = mysqli_connect($host, $user, $password, $db_name);
if (mysqli_connect_errno()) {
    die("Failed to connect with MySQL: " . mysqli_connect_error());
}
?>