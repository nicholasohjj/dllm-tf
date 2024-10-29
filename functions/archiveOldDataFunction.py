import json
import boto3
from datetime import datetime, timezone, timedelta
from decimal import Decimal

# Initialize clients for DynamoDB and S3
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')

# Define DynamoDB table and S3 bucket
TABLE_NAME = 'VibrationData'
BUCKET_NAME = 'archived-data-dllm'
S3_KEY = 'archive/oldData.json'

def lambda_handler(event, context):
    # Initialize DynamoDB table
    table = dynamodb.Table(TABLE_NAME)
    
    # Calculate the cutoff time in UTC (10 minutes ago)
    current_time_utc = datetime.now(timezone.utc)
    cutoff_time_utc = current_time_utc - timedelta(minutes=10)
    cutoff_iso = cutoff_time_utc.strftime('%Y-%m-%dT%H:%M:%SZ')  # ISO 8601 format
    
    # Scan items with a FilterExpression for items older than the cutoff time
    response = table.scan(
        FilterExpression='#ts < :cutoff_time',
        ExpressionAttributeNames={'#ts': 'timestamp_value'},
        ExpressionAttributeValues={':cutoff_time': cutoff_iso}
    )
    
    items_to_archive = response.get('Items', [])
    
    if not items_to_archive:
        print("No items older than 10 minutes to archive.")
        return {
            'statusCode': 200,
            'body': json.dumps('No data found for archiving')
        }
    
    # Retrieve existing data from S3 (if any)
    try:
        s3_response = s3.get_object(Bucket=BUCKET_NAME, Key=S3_KEY)
        existing_data = json.loads(s3_response['Body'].read().decode('utf-8'))
    except s3.exceptions.NoSuchKey:
        # Initialize empty list if file does not exist
        existing_data = []

    # Add new items to the existing data list
    existing_data.extend(items_to_archive)
    
    # Save updated data back to S3
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=S3_KEY,
        Body=json.dumps(existing_data, cls=DecimalEncoder)
    )
    
    # Delete archived items from DynamoDB
    total_archived = 0
    for item in items_to_archive:
        table.delete_item(
            Key={
                'timestamp_value': item['timestamp_value'],
                'machine_id': item['machine_id']
            }
        )
        total_archived += 1
    
    return {
        'statusCode': 200,
        'body': json.dumps(f"Archived {total_archived} items to S3 and removed from DynamoDB.")
    }

# Custom encoder for handling Decimal type in DynamoDB items
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)
