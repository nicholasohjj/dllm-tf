output "MachineStatusTableValue" {
  description = "The ARN of the MachineStatusTable"
  value       = aws_dynamodb_table.MachineStatusTable.arn
}

output "MachineStatusFunctionURL" {
  value = aws_lambda_function_url.fetchMachineStatusFunction.function_url
}