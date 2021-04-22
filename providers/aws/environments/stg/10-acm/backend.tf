terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
