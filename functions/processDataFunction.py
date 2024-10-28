import boto3
import json
from decimal import Decimal
from datetime import datetime, timedelta, timezone

# Initialize DynamoDB resources
dynamodb = boto3.resource('dynamodb')
vibration_table = dynamodb.Table('VibrationData')
status_table = dynamodb.Table('MachineStatusTable')

def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)  # Or use int(obj) if you want integers
    raise TypeError

def process_vibration_data(vibration_data, threshold=1):
    if vibration_data < threshold:
        return "complete"
    else:
        return "in-use"
        
def lambda_handler(event, context):
    try:
        # Get current time in SGT (UTC+8)
        current_time = datetime.now(timezone(timedelta(hours=8)))
        time_threshold = current_time - timedelta(minutes=5)
        
        print(f"--- Debug Info ---\nCurrent Time (SGT): {current_time}\nProcessing Data from: {time_threshold} onwards\n--- End Debug ---")
        
        response = vibration_table.scan()
        items = response.get('Items', [])
        
        # Handle pagination
        while 'LastEvaluatedKey' in response:
            response = vibration_table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            items.extend(response.get('Items', []))
        
        print(f"Items Retrieved: {json.dumps(items, default=decimal_default)}")
        
        for item in items:
            try:
                # No more payload, access fields directly
                if isinstance(item['vibration'], (int, float, Decimal)):
                    vibration_data = float(item['vibration'])
                else:
                    print(f"Invalid data type for vibration: {item['vibration']}") 
                    continue
                
                timestamp_value_str = item.get('timestamp_value')
                if timestamp_value_str:
                    # Assuming timestamp_value is already in SGT, no need to convert it
                    item_time = datetime.strptime(timestamp_value_str, "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone(timedelta(hours=8)))
                else:
                    print(f"Missing timestamp_value for item: {item}")
                    continue
                
                print(item_time, time_threshold)

                if item_time >= time_threshold:
                    status = process_vibration_data(vibration_data)
                    # Update only the status and lastUpdated fields
                    status_table.update_item(
                        Key={'timestamp_value': item['timestamp_value']},  # Use 'timestamp_value' instead of 'machineID'
                        UpdateExpression="SET #st = :status, lastUpdated = :lastUpdated",
                        ExpressionAttributeNames={
                            '#st': 'status'
                        },
                        ExpressionAttributeValues={
                            ':status': status,
                            ':lastUpdated': timestamp_value_str
                        }
                    )

                    print(f"Updated machine {item['machine_id']} with status {status}")
            
            except Exception as inner_e:
                print(f"Error processing item {item}: {str(inner_e)}")
        
    except Exception as e:
        print(f"Error: {str(e)}")
