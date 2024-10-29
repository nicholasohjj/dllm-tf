resource "aws_iam_role" "modifyMachineStatusRole" {
  name = "modifyMachineStatusRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  path = "/service-role/"
}

resource "aws_iam_role" "processDataRole" {
  name = "processDataRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  path = "/service-role/"
}

resource "aws_iam_policy" "process_data_policy" {
  name        = "processDataPolicy"
  description = "Policy to allow DynamoDB scan access for VibrationData table and update access for MachineStatusTable"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:Scan"
        ],
        "Resource" : "arn:aws:dynamodb:ap-southeast-1:149536472280:table/VibrationData"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:UpdateItem"
        ],
        "Resource" : "arn:aws:dynamodb:ap-southeast-1:149536472280:table/MachineStatusTable"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "process_data_role_attach" {
  role       = aws_iam_role.processDataRole.name
  policy_arn = aws_iam_policy.process_data_policy.arn
}

resource "aws_iam_role" "modifyWebConnectionsRole" {
  name = "modifyWebConnectionsRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  path = "/service-role/"
}

resource "aws_iam_role" "archiveOldDataRole" {
  name = "archiveOldDataRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  path = "/service-role/"
}

resource "aws_iam_policy" "archive_data_policy" {
  name        = "archiveDataPolicy"
  description = "Policy to allow Lambda function to archive data to S3"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject"
        ],
        "Resource": "arn:aws:s3:::archived-data-dllm/archive/*"  # Ensure bucket name and path are correct here
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket"
        ],
        "Resource": "arn:aws:s3:::archived-data-dllm"  # Allow list operation at bucket level
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "archive_data_role_attach" {
  role       = aws_iam_role.archiveOldDataRole.name
  policy_arn = aws_iam_policy.archive_data_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.modifyMachineStatusRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_execution_role" {
  role       = aws_iam_role.modifyMachineStatusRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}
