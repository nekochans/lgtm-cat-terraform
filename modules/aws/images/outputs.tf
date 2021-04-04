output "upload_images_bucket_name" {
  value = aws_s3_bucket.upload_images_bucket.bucket
}

output "lgtm_images_bucket_name" {
  value = aws_s3_bucket.lgtm_images_bucket.bucket
}
