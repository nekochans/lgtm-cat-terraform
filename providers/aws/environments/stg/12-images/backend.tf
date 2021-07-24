terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "images/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"

  config = {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
