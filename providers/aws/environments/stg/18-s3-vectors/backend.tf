terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "s3-vectors/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
