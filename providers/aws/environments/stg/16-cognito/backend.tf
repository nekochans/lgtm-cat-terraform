terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "cognito/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}

data "terraform_remote_state" "ses" {
  backend = "s3"

  config = {
    bucket  = "lgtm-cat-tfstate"
    key     = "ses/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
