resource "aws_apigatewayv2_api" "api" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
  target        = var.lambda_arn
}

resource "aws_apigatewayv2_route" "api" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.api.id}"
  authorization_type = "NONE"
}

resource "aws_apigatewayv2_integration" "api" {
  api_id = aws_apigatewayv2_api.api.id

  integration_type   = "AWS_PROXY"
  connection_type    = "INTERNET"
  description        = "${var.api_gateway_name} serverless api"
  integration_method = "POST"
  integration_uri    = var.lambda_invoke_arn
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = var.api_gateway_domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.api.id
  stage       = "$default"
  domain_name = aws_apigatewayv2_domain_name.api.domain_name
}
