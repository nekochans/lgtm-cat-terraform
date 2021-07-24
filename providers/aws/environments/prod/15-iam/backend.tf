terraform {
  backend "s3" {
    bucket  = "lgtm-cat-tfstate"
    key     = "iam/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
