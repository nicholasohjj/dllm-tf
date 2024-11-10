import json
import boto3
import joblib
import pandas as pd
from sklearn.tree import DecisionTreeClassifier

# Initialize clients for S3 and DynamoDB
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

# Define your table and S3 model bucket information
table_name = "CameraImageJSON"
bucket_name = "pretrained-model-dllm"
model_key = "json_model.joblib"  # Adjust if the model is in a subfolder

# Define Lambda handler
def lambda_handler(event, context):
    # Connect to the DynamoDB table
    table = dynamodb.Table(table_name)

    # Query DynamoDB to fetch the latest item
    try:
        response = table.scan(
            ProjectionExpression="pose_keypoints_2d, timestamp_value",  # Ensure "timestamp" is an attribute
        )
        
        # Sort by timestamp to find the latest item
        items = sorted(response.get('Items', []), key=lambda x: x['timestamp_value'], reverse=True)
        if not items:
            return {
                'statusCode': 400,
                'body': "Error: No data found in CameraImageJSON table."
            }
        
        latest_item = items[0]
        pose_keypoints = latest_item.get("pose_keypoints_2d", [])
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: Failed to retrieve data from DynamoDB. {str(e)}"
        }

    if not pose_keypoints:
        return {
            'statusCode': 400,
            'body': "Error: 'pose_keypoints_2d' data not found or is empty."
        }

    # Convert to DataFrame
    df = pd.DataFrame([pose_keypoints])

    # Fetch and load the model from S3
    try:
        s3.download_file(bucket_name, model_key, '/tmp/json_model.joblib')
        clf = joblib.load('/tmp/json_model.joblib')
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: Failed to load model from S3. {str(e)}"
        }

    # Make the prediction
    try:
        prediction = clf.predict(df)
        return {
            'statusCode': 200,
            'body': json.dumps({"prediction": prediction.tolist()})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: Prediction failed. {str(e)}"
        }
