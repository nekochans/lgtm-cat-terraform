resource "aws_route53_record" "image_recognition_api" {
  zone_id = var.zone_id
  name    = aws_apigatewayv2_domain_name.image_recognition_api.domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.image_recognition_api.domain_name_configuration.0.target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.image_recognition_api.domain_name_configuration.0.hosted_zone_id
    evaluate_target_health = false
  }
}
