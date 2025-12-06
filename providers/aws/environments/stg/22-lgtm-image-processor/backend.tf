terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "lgtm-image-processor/terraform.tfstate"
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
