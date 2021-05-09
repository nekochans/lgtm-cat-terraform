terraform {
  backend "s3" {
    bucket  = "lgtm-cat-tfstate"
    key     = "ses/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
