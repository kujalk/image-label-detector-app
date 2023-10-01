resource "aws_apigatewayv2_api" "apigw" {
  name          = "${var.project}-http-endpoint"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["GET", "OPTIONS"]
    allow_origins = ["*"]
  }
}


resource "aws_apigatewayv2_integration" "apigw" {
  api_id             = aws_apigatewayv2_api.apigw.id
  integration_type   = "AWS_PROXY"
  connection_type    = "INTERNET"
  description        = "${var.project} http lambda integration"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.apigw_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "apigw" {
  api_id    = aws_apigatewayv2_api.apigw.id
  route_key = "GET /api/v1/identify"

  target             = "integrations/${aws_apigatewayv2_integration.apigw.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.apigw.id
}

resource "aws_apigatewayv2_stage" "apigw" {
  api_id      = aws_apigatewayv2_api.apigw.id
  name        = var.apigw_stage
  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "apigw" {
  api_id          = aws_apigatewayv2_api.apigw.id
  authorizer_type = "JWT"
  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://${aws_cognito_user_pool.user_pool.endpoint}"
  }
  identity_sources = ["$request.header.Authorization"]
  name             = "jwt-access"
}