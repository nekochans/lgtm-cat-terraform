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
