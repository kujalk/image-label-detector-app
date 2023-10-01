import boto3
from urllib.parse import unquote
import os 

def lambda_handler(event, context):
    
    print(event)

    # Initialize the AWS clients
    rekognition_client = boto3.client('rekognition')
    dynamodb_client = boto3.client('dynamodb')

    # Extract relevant information from the S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']
    object_key = unquote(object_key)
    cognito_id, image_key = object_key.split('/')[1], object_key.split('/')[2]
    
    print(f"bucket name {bucket_name}, object key {object_key}, cognitoid {cognito_id}")

    # Use Amazon Rekognition to identify labels in the image
    response = rekognition_client.detect_labels(
        Image={'S3Object':{'Bucket': bucket_name,'Name': object_key}},
        MaxLabels=10, MinConfidence=70
    )
    detected_labels = [label['Name'] for label in response['Labels']]

    print(f"Detected labels are {detected_labels}")
    
    # Write the data to DynamoDB
    dynamodb_client.put_item(
        TableName=os.getenv('DynamoDB_Table'), # Replace with your actual table name
        Item={
            'cognitoid': {'S': cognito_id},
            'imagename': {'S': image_key},
            'labels': {'S': str(detected_labels)}
        }
    )

    return {
        'statusCode': 200,
        'body': 'Labels detected and data written to DynamoDB.'
    }
