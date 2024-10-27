
# Lambda Functions

resource "aws_lambda_function" "seedMachineFunction" {
  function_name    = "seedMachineFunction"
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  filename         = "functions/seedMachineFunction.zip"
  source_code_hash = filebase64sha256("functions/seedMachineFunction.zip")
  role             = aws_iam_role.modifyMachineStatusRole.arn
  environment {
    variables = {
      MACHINE_STATUS_TABLE = aws_dynamodb_table.MachineStatusTable.name
    }
  }
}

resource "aws_lambda_function" "disconnectFunction" {
  function_name    = "disconnectFunction"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "functions/disconnectFunction.zip"
  source_code_hash = filebase64sha256("functions/disconnectFunction.zip")
  role             = aws_iam_role.modifyWebConnectionsRole.arn
  environment {
    variables = {
      WEB_SOCKET_CONNECTIONS_TABLE = aws_dynamodb_table.WebSocketConnections.name
    }
  }
}

resource "aws_lambda_function" "connectFunction" {
  function_name    = "connectFunction"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "functions/connectFunction.zip"
  source_code_hash = filebase64sha256("functions/connectFunction.zip")
  role             = aws_iam_role.modifyWebConnectionsRole.arn
  environment {
    variables = {
      WEB_SOCKET_CONNECTIONS_TABLE = aws_dynamodb_table.WebSocketConnections.name
    }
  }
}

resource "aws_lambda_function" "processDataRole" {
  function_name    = "processDataRole"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "functions/processVibrationDataFunction.zip"
  source_code_hash = filebase64sha256("functions/processVibrationDataFunction.zip")
  role             = aws_iam_role.processDataRole.arn
  environment {
    variables = {
      VIBRATION_DATA_TABLE = aws_dynamodb_table.VibrationData.name
      MACHINE_STATUS_TABLE = aws_dynamodb_table.MachineStatusTable.name
    }

  }
}

resource "aws_lambda_function" "fetchMachineStatusFunction" {
  function_name    = "fetchMachineStatusFunction"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "functions/fetchMachineStatusFunction.zip"
  source_code_hash = filebase64sha256("functions/fetchMachineStatusFunction.zip")
  role             = aws_iam_role.modifyMachineStatusRole.arn
  environment {
    variables = {
      MACHINE_STATUS_TABLE = aws_dynamodb_table.MachineStatusTable.name
    }
  }
}

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

resource "aws_lambda_function" "archiveOldDataFunction" {
  function_name    = "archiveOldDataFunction"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "functions/archiveOldDataFunction.zip"
  source_code_hash = filebase64sha256("functions/archiveOldDataFunction.zip")
  role             = aws_iam_role.archiveOldDataRole.arn
  environment {
    variables = {
      VIBRATION_DATA_TABLE = aws_dynamodb_table.VibrationData.name
    }
  }
}
