terraform {
  backend "s3" {
    bucket  = "lgtm-cat-tfstate"
    key     = "rds/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket  = "lgtm-cat-tfstate"
    key     = "network/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}

data "terraform_remote_state" "stg_lambda_securitygroup" {
  backend = "s3"

  config = {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "lambda-securitygroup/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
