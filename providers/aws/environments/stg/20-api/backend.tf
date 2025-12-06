terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "api/terraform.tfstate"
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

data "terraform_remote_state" "acm" {
  backend = "s3"

  config = {
    bucket  = "lgtm-cat-tfstate"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}

data "terraform_remote_state" "images" {
  backend = "s3"

  config = {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "images/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}

data "terraform_remote_state" "cognito" {
  backend = "s3"

  config = {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "cognito/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}

data "terraform_remote_state" "s3_vectors" {
  backend = "s3"

  config = {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "s3-vectors/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
