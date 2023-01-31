resource "aws_route53_record" "api_public" {
  name    = var.ecs_domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_alb.api_public.dns_name
    zone_id                = aws_alb.api_public.zone_id
  }
}
