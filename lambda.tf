# Archive Files for Lambda Functions
# Each function is zipped and stored as an archived file, ready for deployment.
data "archive_file" "archiveOldDataFunction" {
  type        = "zip"
  source_file = "functions/archiveOldDataFunction.py"
  output_path = "functions/archiveOldDataFunction.zip"
}

data "archive_file" "postCameraImageJSONFunction" {
  type        = "zip"
  source_file = "functions/postCameraImageJSONFunction.py"
  output_path = "functions/postCameraImageJSONFunction.zip"
}

data "archive_file" "seedMachineFunction" {
  type        = "zip"
  source_file = "functions/seedMachineFunction.mjs"
  output_path = "functions/seedMachineFunction.zip"
}

data "archive_file" "disconnectFunction" {
  type        = "zip"
  source_file = "functions/disconnectFunction.py"
  output_path = "functions/disconnectFunction.zip"
}

data "archive_file" "connectFunction" {
  type        = "zip"
  source_file = "functions/connectFunction.py"
  output_path = "functions/connectFunction.zip"
}

data "archive_file" "processDataFunction" {
  type        = "zip"
  source_file = "functions/processDataFunction.py"
  output_path = "functions/processDataFunction.zip"
}

data "archive_file" "fetchMachineStatusFunction" {
  type        = "zip"
  source_file = "functions/fetchMachineStatusFunction.py"
  output_path = "functions/fetchMachineStatusFunction.zip"
}

# Lambda Functions
# Each Lambda function resource references an archive file for deployment

# Seed Machine Function
resource "aws_lambda_function" "seedMachineFunction" {
  function_name    = "seedMachineFunction"
  handler          = "seedMachineFunction.handler"
  runtime          = "nodejs20.x"
  filename         = data.archive_file.seedMachineFunction.output_path
  source_code_hash = data.archive_file.seedMachineFunction.output_base64sha256
  role             = aws_iam_role.modifyMachineStatusRole.arn
  environment {
    variables = {
      MACHINE_STATUS_TABLE = aws_dynamodb_table.MachineStatusTable.name
    }
  }
}

# Disconnect Function for WebSocket Disconnections
resource "aws_lambda_function" "disconnectFunction" {
  function_name    = "disconnectFunction"
  handler          = "disconnectFunction.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.disconnectFunction.output_path
  source_code_hash = data.archive_file.disconnectFunction.output_base64sha256
  role             = aws_iam_role.modifyWebConnectionsRole.arn
  environment {
    variables = {
      WEB_SOCKET_CONNECTIONS_TABLE = aws_dynamodb_table.WebSocketConnections.name
    }
  }
}

# Connect Function for WebSocket Connections
resource "aws_lambda_function" "connectFunction" {
  function_name    = "connectFunction"
  handler          = "connectFunction.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.connectFunction.output_path
  source_code_hash = data.archive_file.connectFunction.output_base64sha256
  role             = aws_iam_role.modifyWebConnectionsRole.arn
  environment {
    variables = {
      WEB_SOCKET_CONNECTIONS_TABLE = aws_dynamodb_table.WebSocketConnections.name
    }
  }
}

# Process Data Function
resource "aws_lambda_function" "processDataFunction" {
  function_name    = "processDataFunction"
  handler          = "processDataFunction.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.processDataFunction.output_path
  source_code_hash = data.archive_file.processDataFunction.output_base64sha256
  role             = aws_iam_role.processDataRole.arn
  environment {
    variables = {
      VIBRATION_DATA_TABLE = aws_dynamodb_table.VibrationData.name
      MACHINE_STATUS_TABLE = aws_dynamodb_table.MachineStatusTable.name
    }

  }
}

# Fetch Machine Status Function with a public URL
resource "aws_lambda_function" "fetchMachineStatusFunction" {
  function_name    = "fetchMachineStatusFunction"
  handler          = "fetchMachineStatusFunction.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.fetchMachineStatusFunction.output_path
  source_code_hash = data.archive_file.fetchMachineStatusFunction.output_base64sha256
  role             = aws_iam_role.modifyMachineStatusRole.arn
  environment {
    variables = {
      MACHINE_STATUS_TABLE = aws_dynamodb_table.MachineStatusTable.name
    }
  }
}

# Public URL for Fetch Machine Status Function
resource "aws_lambda_function_url" "fetchMachineStatusFunction" {
  function_name      = aws_lambda_function.fetchMachineStatusFunction.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["http://localhost:5173", "https://dllmnus.vercel.app"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# Archive Old Data Function for Data Archiving
resource "aws_lambda_function" "archiveOldDataFunction" {
  function_name    = "archiveOldDataFunction"
  handler          = "archiveOldDataFunction.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.archiveOldDataFunction.output_path
  source_code_hash = data.archive_file.archiveOldDataFunction.output_base64sha256
  role             = aws_iam_role.archiveOldDataRole.arn
  environment {
    variables = {
      VIBRATION_DATA_TABLE  = aws_dynamodb_table.VibrationData.name
      ARCHIVE_BUCKET_NAME   = "archived-data-dllm"  # Define your S3 bucket name
      ARCHIVE_S3_KEY        = "archive/oldData.json"  # Define your S3 key path
    }
  }
}

resource "aws_lambda_function" "postCameraImageJSONFunction" {
  function_name    = "postCameraImageJSONFunction"
  handler          = "postCameraImageJSONFunction.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.postCameraImageJSONFunction.output_path
  source_code_hash = data.archive_file.postCameraImageJSONFunction.output_base64sha256
  role             = aws_iam_role.postCameraImageJSONRole.arn
  environment {
    variables = {
      CAMERA_IMAGE_JSON_TABLE = aws_dynamodb_table.CameraImageJSON.name
    }
  }
}

resource "aws_lambda_function_url" "postCameraImageJSONFunction" {
  function_name      = aws_lambda_function.postCameraImageJSONFunction.function_name
  authorization_type = "NONE"

    cors {
    allow_credentials = true
    allow_origins     = ["http://localhost:5173", "https://dllmnus.vercel.app"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
