terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "q-developer-chat/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
