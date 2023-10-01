import boto3
import json
import os

# Initialize client
identity = boto3.client('cognito-identity')
dynamodb = boto3.client('dynamodb')

# Replace 'your_identity_pool_id' with your actual Identity Pool ID
IDENTITY_POOL_ID = os.getenv("IdentityPool_ID")

def get_id(jwt_token, issuer):
    try:
        print(f"Received Data is {jwt_token} - {issuer}")

        response = identity.get_id(
            IdentityPoolId=IDENTITY_POOL_ID,
            Logins={issuer.replace("https://", ""): jwt_token}
        )
        return None, response['IdentityId']
    
    except Exception as e:
        return e, None

def lambda_handler(event, context):
    
    print(f"Hello , API data {event}")

    issuer = event['requestContext']['authorizer']['claims']['iss']
    authorization = event['headers']['authorization']
    
    print(f"Query string is {event['queryStringParameters']}")
    
    error, identity_id = get_id(authorization, issuer)
    
    print(f"val is {error} {identity_id}")
    data = {"error":error,"identity":identity_id}
    
    # Define the table name
    table_name = os.getenv('DynamoDB_Table')
    
    # Define the key values for the query
    api_param_key = list(event['queryStringParameters'].keys())[0]
    api_param_value = event['queryStringParameters'][api_param_key]
    
    if(api_param_value == '' or  api_param_value==None):
        print("parameter string is empty")
        return {
        'statusCode': 400,
        'body':json.dumps([])
    }
 
    
    cognitoid_value = identity_id
     
    if(api_param_key== "image"):
        KeyConditionExpression='imagename = :api_value AND cognitoid = :cognitoid_value'
        
        # Query the DynamoDB table
        response = dynamodb.query(
            TableName=table_name,
            KeyConditionExpression=KeyConditionExpression,
            ExpressionAttributeValues={
                ':api_value': {'S': api_param_value},
                ':cognitoid_value': {'S': cognitoid_value}
            }
        )
    
    else:
        # Define the PartiQL query
        query = f"""
            SELECT * FROM "{table_name}" WHERE CONTAINS("labels", '{api_param_value}') AND "cognitoid" = '{cognitoid_value}'
        """

        response = dynamodb.execute_statement(Statement=query)
        
    # Extract the items from the response
    items = response.get('Items', [])
    
    # Convert the items to a list of dictionaries
    records = []
    for item in items:
        record = {}
        for key, value in item.items():
            record[key] = list(value.values())[0]
        records.append(record)
    
    
    return {
        'statusCode': 200,
        'body':json.dumps(records)
    }
