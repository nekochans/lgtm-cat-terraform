terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "lgtm-image-processor/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
