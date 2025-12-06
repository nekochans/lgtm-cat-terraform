terraform {
  backend "s3" {
    bucket  = "lgtm-cat-tfstate"
    key     = "s3-vectors/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
