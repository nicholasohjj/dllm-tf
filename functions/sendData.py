import requests
import json

# Replace with your Lambda function URL
lambda_url = 'https://v6uenqf62ikboz5ejqojqkstp40rgawe.lambda-url.ap-southeast-1.on.aws/'  

# JSON data to post
json_data = {
    "id": "unique_id",
    "attribute1": "value1",
    "attribute2": "value2",
    
    # Add more attributes as needed
}

# Send POST request
response = requests.post(lambda_url, json=json_data)

# Check response
if response.status_code == 200:
    print("Data posted successfully:", response.json())
else:
    print("Failed to post data:", response.text)
