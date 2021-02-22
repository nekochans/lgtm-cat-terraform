terraform {
  backend "s3" {
    bucket  = "lgtm-cat-tfstate"
    key     = "images/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
