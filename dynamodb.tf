resource "aws_dynamodb_table" "MachineStatusTable" {
  name         = var.MachineStatusTable
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "machineID"
  attribute {
    name = "machineID"
    type = "S"
  }

  tags = {
    Name        = "MachineStatusTable"
    Environment = "production"
    Project     = "DLLM"
    Owner       = "Nicholas"
  }
}

resource "aws_dynamodb_table" "VibrationData" {
  name         = var.VibrationData
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "timestamp_value"
  range_key    = "machineID"

  attribute {
    name = "timestamp_value"
    type = "S"
  }

  attribute {
    name = "machineID"
    type = "S"
  }

  tags = {
    Name        = "VibrationData"
    Environment = "production"
    Project     = "DLLM"
    Owner       = "Nicholas"
  }
}

resource "aws_dynamodb_table" "WebSocketConnections" {
  name         = "WebSocketConnections"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "connectionID"

  ttl {
    attribute_name = "ExpirationTime"
    enabled        = "true"
  }

  attribute {
    name = "connectionID"
    type = "S"
  }

  tags = {
    Name        = "WebSocketConnections"
    Environment = "production"
    Project     = "DLLM"
    Owner       = "Nicholas"
  }
}
