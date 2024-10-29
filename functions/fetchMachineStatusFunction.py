import boto3
import json
import os
from decimal import Decimal

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
machine_status_table = dynamodb.Table(os.environ['MACHINE_STATUS_TABLE'])

# Custom encoder to convert Decimal to float
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj) if obj % 1 else int(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    # Log the event for debugging
    print(f"Received event: {json.dumps(event)}")
    
    # Scan the MachineStatusTable to get all items
    try:
        items = []
        # Use pagination to scan the entire table
        response = machine_status_table.scan()
        items.extend(response.get('Items', []))
        
        # Check if there's more data to be retrieved
        while 'LastEvaluatedKey' in response:
            response = machine_status_table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            items.extend(response.get('Items', []))
        
        # Create a response with the scanned items
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Machine status retrieved successfully',
                'data': items  # Send the entire table data as the response
            }, cls=DecimalEncoder),  # Use the custom encoder to handle Decimal types
            'headers': {
                'Content-Type': 'application/json'
            }
        }
    except Exception as e:
        # Handle any errors in querying the table
        print(f"Error fetching data from DynamoDB: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to fetch machine status'}),
            'headers': {
                'Content-Type': 'application/json'
            }
        }
