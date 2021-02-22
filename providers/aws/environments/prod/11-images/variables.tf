locals {
  env                     = "prod"
  name                    = "lgtmeow"
  lgtm_images_bucket_name = "${local.env}-${local.name}-images"
}
