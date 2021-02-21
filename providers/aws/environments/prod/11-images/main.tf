module "images" {
  source                  = "../../../../../modules/aws/images"
  lgtm_images_bucket_name = local.lgtm_images_bucket_name
}
