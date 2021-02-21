terraform {
  backend "s3" {
    bucket  = "prod-nekochans-tfstate"
    key     = "network/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-prod"
  }
}
