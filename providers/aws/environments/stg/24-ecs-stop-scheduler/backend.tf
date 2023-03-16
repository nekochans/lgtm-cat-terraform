terraform {
  backend "s3" {
    bucket  = "stg-lgtm-cat-tfstate"
    key     = "ecs-stop-scheduler/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "lgtm-cat"
  }
}
