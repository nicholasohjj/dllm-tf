import json
import boto3
import os
from datetime import datetime

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['CAMERA_IMAGE_JSON_TABLE']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Parse JSON data from the POST request
    try:
        json_data = json.loads(event['body'])
        
        # Ensure timestamp_value is present
        if 'timestamp_value' not in json_data:
            # Add a timestamp if not present, using the current date and time
            json_data['timestamp_value'] = datetime.utcnow().isoformat()
        
        # Insert item into DynamoDB table
        response = table.put_item(Item=json_data)
        
        return {
            'statusCode': 200,
            'body': json.dumps('Data inserted successfully')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error inserting data: {str(e)}")
        }
