resource "aws_route53_zone" "rds_stg" {
  name = "stg"

  vpc {
    vpc_id = var.vpc_id
  }

  comment = "stg RDS Local Domain"
}

resource "aws_route53_record" "rds_stg" {
  zone_id = aws_route53_zone.rds_stg.zone_id
  name    = var.rds_domain_name
  type    = "CNAME"

  ttl     = 300
  records = [aws_rds_cluster.rds_cluster.endpoint]
}

resource "aws_route53_zone" "rds" {
  name = "prod"

  vpc {
    vpc_id = var.vpc_id
  }

  comment = "prod RDS Local Domain"
}

resource "aws_route53_record" "rds" {
  zone_id = aws_route53_zone.rds.zone_id
  name    = var.rds_domain_name
  type    = "CNAME"

  ttl     = 300
  records = [aws_rds_cluster.rds_cluster.endpoint]
}
