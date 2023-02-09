resource "aws_apigatewayv2_domain_name" "image_recognition_api" {
  domain_name = var.image_recognition_api_gateway_domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "image_recognition_api" {
  api_id      = var.image_recognition_api_gateway_id
  stage       = "$default"
  domain_name = aws_apigatewayv2_domain_name.image_recognition_api.domain_name
}
