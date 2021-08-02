resource "aws_route53_record" "apigateway" {
  zone_id = var.zone_id
  name    = aws_apigatewayv2_domain_name.api.domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.api.domain_name_configuration.0.target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api.domain_name_configuration.0.hosted_zone_id
    evaluate_target_health = false
  }
}
