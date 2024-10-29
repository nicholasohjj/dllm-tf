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
    
    total_archived = 0
    for item in items_to_archive:
        timestamp_str = item['timestamp_value'].replace(":", "-")  # Adjust for filename compatibility
        s3_key = f'archive/vibration_data_{item["machine_id"]}_{timestamp_str}.json'
        
        # Save item to S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=s3_key,
            Body=json.dumps(item, cls=DecimalEncoder)
        )
        
        # Delete item from DynamoDB
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
