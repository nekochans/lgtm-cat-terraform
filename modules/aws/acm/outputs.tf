output "sub_domain_acm_arn" {
  value = data.aws_acm_certificate.sub.arn
}
