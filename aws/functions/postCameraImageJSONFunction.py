import json
import boto3
import os
from datetime import datetime

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table_name = "MachineStatusTable"  # Set to MachineStatusTable
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    try:
        # Ensure 'body' is in the event, otherwise return an error
        if 'body' not in event:
            return {
                'statusCode': 400,
                'body': json.dumps('Error: Missing body in request')
            }
        
        # Parse JSON data from the POST request
        json_data = json.loads(event['body'])
        
        # Check and map 'machine_id' to 'machineID' for the DynamoDB key
        if 'machine_id' not in json_data:
            return {
                'statusCode': 400,
                'body': json.dumps('Error: machine_id is required')
            }
        
        machine_id = json_data.pop('machine_id')
        
        # Set 'status' to "available" or "in-use" based on 'available' field
        if 'available' in json_data:
            status = "available" if json_data.pop('available') == 1 else "in-use"
        else:
            status = "in-use"  # Default to "in-use" if 'available' is not provided
        
        # Update the item in DynamoDB
        response = table.update_item(
            Key={'machineID': machine_id},
            UpdateExpression="SET #s = :status",
            ExpressionAttributeNames={
                '#s': 'status'  # Using an alias to avoid reserved keywords
            },
            ExpressionAttributeValues={
                ':status': status
            },
            ReturnValues="UPDATED_NEW"
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps('Status updated successfully')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error updating data: {str(e)}")
        }
