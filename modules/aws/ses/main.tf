resource "aws_ses_domain_identity" "ses" {
  domain = var.main_domain_name
}

data "aws_route53_zone" "main" {
  name = var.main_domain_name
}

resource "aws_route53_record" "ses_txt_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "_amazonses.${data.aws_route53_zone.main.name}"
  type    = "TXT"
  ttl     = "600"
  records = [
    aws_ses_domain_identity.ses.verification_token
  ]
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = var.main_domain_name
}

resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${data.aws_route53_zone.main.name}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_ses_email_identity" "from_email" {
  email = var.from_email
}
