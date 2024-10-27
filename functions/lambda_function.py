import boto3
import json
from decimal import Decimal

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
machine_status_table = dynamodb.Table('MachineStatusTable')

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
import json
import boto3
import time
from datetime import datetime

# Initialize clients for DynamoDB and S3
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')

# Define DynamoDB table and S3 bucket
TABLE_NAME = 'VibrationData'
BUCKET_NAME = 'dllmarchiveddata'

def lambda_handler(event, context):
    # Initialize DynamoDB table
    table = dynamodb.Table(TABLE_NAME)
    
    # Get the current time and calculate the cutoff timestamp for data older than 10 minutes
    current_time = int(time.time())
    cutoff_time = current_time - 600  # 600 seconds = 10 minutes
    
    # Query DynamoDB for items older than 10 minutes
    response = table.scan(
        FilterExpression='#ts < :cutoff_time',
        ExpressionAttributeNames={'#ts': 'timestamp_value'},  # Substitute 'timestamp_value' with an alias
        ExpressionAttributeValues={':cutoff_time': cutoff_time}
    )
    
    items_to_archive = response['Items']
    
    if not items_to_archive:
        print("No items older than 10 minutes to archive.")
        return {
            'statusCode': 200,
            'body': json.dumps('No data found for archiving')
        }
    
    # Archive each item to S3 and delete from DynamoDB
    for item in items_to_archive:
        # Convert timestamp to human-readable format for better S3 key naming
        timestamp = datetime.utcfromtimestamp(item['timestamp_value']).strftime('%Y-%m-%d_%H-%M-%S')
        s3_key = f'archive/vibration_data_{timestamp}.json'
        
        # Save item to S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=s3_key,
            Body=json.dumps(item)
        )
        
        # Delete item from DynamoDB
        table.delete_item(
            Key={'timestamp_value': item['timestamp_value']}  # Use 'timestamp_value' as the partition key
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps(f"Archived {len(items_to_archive)} items to S3 and removed from DynamoDB.")
    }
