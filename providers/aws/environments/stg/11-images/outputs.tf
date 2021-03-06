output "upload_images_bucket_name" {
  value = module.images.upload_images_bucket_name
}

output "lgtm_images_bucket_name" {
  value = module.images.lgtm_images_bucket_name
}

output "lgtm_images_cdn_domain" {
  value = local.lgtm_images_cdn_domain
}
