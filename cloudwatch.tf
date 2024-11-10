resource "aws_cloudwatch_event_rule" "archiveOldDataRule" {
  name                = "archiveOldDataRule"
  description         = "Archive old data from VibrationData table"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "archiveOldDataTarget" {
  rule      = aws_cloudwatch_event_rule.archiveOldDataRule.name
  target_id = "archiveOldDataTarget"
  arn       = aws_lambda_function.archiveOldDataFunction.arn
}

resource "aws_cloudwatch_event_rule" "processDataRule" {
  name                = "processDataRule"
  description         = "Process Vibration Data"
  schedule_expression = "rate(5 minutes)"
}