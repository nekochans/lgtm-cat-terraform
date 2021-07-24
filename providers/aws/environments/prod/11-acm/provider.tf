provider "aws" {
  region  = "ap-northeast-1"
  profile = "lgtm-cat"
}

provider "aws" {
  region  = "us-east-1"
  profile = "lgtm-cat"
  alias   = "us-east-1"
}
