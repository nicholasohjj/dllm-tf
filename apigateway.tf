# WebSocket API definition
resource "aws_apigatewayv2_api" "MachineStatusAPI" {
  name                        = "MachineStatusAPI"
  protocol_type               = "WEBSOCKET"
  route_selection_expression  = "$request.body.action"
  api_key_selection_expression = "$request.header.x-api-key"
  disable_execute_api_endpoint = false
}

# Integration for Connect Function
resource "aws_apigatewayv2_integration" "connect_integration" {
  api_id             = aws_apigatewayv2_api.MachineStatusAPI.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.connectFunction.invoke_arn
  integration_method = "POST"
}

# Integration for Disconnect Function
resource "aws_apigatewayv2_integration" "disconnect_integration" {
  api_id             = aws_apigatewayv2_api.MachineStatusAPI.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.disconnectFunction.invoke_arn
  integration_method = "POST"
}

# Integration for Fetch Machine Status Function (used as default route)
resource "aws_apigatewayv2_integration" "fetch_machine_status_integration" {
  api_id             = aws_apigatewayv2_api.MachineStatusAPI.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.fetchMachineStatusFunction.invoke_arn
  integration_method = "POST"
}

# Route for $connect with connect integration
resource "aws_apigatewayv2_route" "connect_route" {
  api_id     = aws_apigatewayv2_api.MachineStatusAPI.id
  route_key  = "$connect"
  target     = "integrations/${aws_apigatewayv2_integration.connect_integration.id}"
}

# Route for $disconnect with disconnect integration
resource "aws_apigatewayv2_route" "disconnect_route" {
  api_id     = aws_apigatewayv2_api.MachineStatusAPI.id
  route_key  = "$disconnect"
  target     = "integrations/${aws_apigatewayv2_integration.disconnect_integration.id}"
}

# Route for default action with fetch machine status integration
resource "aws_apigatewayv2_route" "default_route" {
  api_id     = aws_apigatewayv2_api.MachineStatusAPI.id
  route_key  = "$default"
  target     = "integrations/${aws_apigatewayv2_integration.fetch_machine_status_integration.id}"
}

# Permissions for Lambda functions to allow API Gateway invocation
resource "aws_lambda_permission" "connect_permission" {
  statement_id  = "AllowAPIGatewayInvokeConnect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.connectFunction.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.MachineStatusAPI.execution_arn}/*"
}

resource "aws_lambda_permission" "disconnect_permission" {
  statement_id  = "AllowAPIGatewayInvokeDisconnect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.disconnectFunction.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.MachineStatusAPI.execution_arn}/*"
}

# Permission for Fetch Machine Status Lambda function to allow API Gateway invocation
resource "aws_lambda_permission" "fetch_machine_status_permission" {
  statement_id  = "AllowAPIGatewayInvokeFetchMachineStatus"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fetchMachineStatusFunction.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.MachineStatusAPI.execution_arn}/*"
}