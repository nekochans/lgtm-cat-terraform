resource "aws_s3_bucket" "upload_images_bucket" {
  bucket = var.upload_images_bucket_name
  acl    = "private"

  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    enabled = true
    // 失効した削除マーカーまたは不完全なマルチパートアップロードを削除する
    abort_incomplete_multipart_upload_days = 1

    // オブジェクトの有効期限
    expiration {
      days = 10
    }
  }
}

resource "aws_s3_bucket" "cat_images_bucket" {
  bucket = var.cat_images_bucket_name
  acl    = "private"

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    // 失効した削除マーカーまたは不完全なマルチパートアップロードを削除する
    abort_incomplete_multipart_upload_days = 1

    // オブジェクトの有効期限
    expiration {
      days = 10
    }
  }
}

resource "aws_s3_bucket" "created_lgtm_images_bucket" {
  bucket = var.created_lgtm_images_bucket_name
  acl    = "private"

  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    enabled = true
    // 失効した削除マーカーまたは不完全なマルチパートアップロードを削除する
    abort_incomplete_multipart_upload_days = 1

    // オブジェクトの有効期限
    expiration {
      days = 10
    }
  }
}

resource "aws_s3_bucket" "lgtm_images_bucket" {
  bucket = var.lgtm_images_bucket_name
  acl    = "private"

  // TODO 検証の為、何度か作り直しする可能性があるので一時的に force_destroy = true に設定
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    // 失効した削除マーカーまたは不完全なマルチパートアップロードを削除する
    abort_incomplete_multipart_upload_days = 7

    // 古いバージョンは30日で削除
    noncurrent_version_expiration {
      days = 30
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "lgtm_images_bucket" {
  comment = "${aws_s3_bucket.lgtm_images_bucket.bucket} origin access identity"
}

data "aws_iam_policy_document" "read_lgtm_images" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.lgtm_images_bucket.arn}/*"]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.lgtm_images_bucket.iam_arn]
      type        = "AWS"
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.lgtm_images_bucket.arn]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.lgtm_images_bucket.iam_arn]
      type        = "AWS"
    }
  }
}

resource "aws_s3_bucket_policy" "read_lgtm_images" {
  bucket = aws_s3_bucket.lgtm_images_bucket.id
  policy = data.aws_iam_policy_document.read_lgtm_images.json
}

resource "aws_s3_bucket" "lgtm_images_access_logs" {
  bucket        = "${var.lgtm_images_bucket_name}-logs"
  force_destroy = true

  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
  }
}

resource "aws_cloudfront_distribution" "lgtm_images_cdn" {
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    target_origin_id       = "S3-${aws_s3_bucket.lgtm_images_bucket.bucket}"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "LGTMeow Images"

  aliases = [var.lgtm_images_cdn_domain]

  logging_config {
    bucket          = aws_s3_bucket.lgtm_images_access_logs.bucket_domain_name
    include_cookies = false
    prefix          = "raw/"
  }

  origin {
    domain_name = aws_s3_bucket.lgtm_images_bucket.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.lgtm_images_bucket.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.lgtm_images_bucket.cloudfront_access_identity_path
    }

    custom_header {
      name  = "Accept"
      value = "image/png,image/jpeg,image/webp"
    }

    custom_header {
      name  = "Content-Type"
      value = "image/png,image/jpeg,image/webp"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.lgtm_images_cdn_acm_arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "lgtm_images" {
  name    = var.lgtm_images_cdn_sub_domain
  type    = "A"
  zone_id = var.main_host_zone

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.lgtm_images_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.lgtm_images_cdn.hosted_zone_id
  }
}
