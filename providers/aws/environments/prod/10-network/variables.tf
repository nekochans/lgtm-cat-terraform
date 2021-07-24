locals {
  name = "lgtm-cat"

  azs = [
    "ap-northeast-1a",
    "ap-northeast-1c",
  ]

  cidr = "10.1.0.0/16"

  public_subnets = [
    "10.1.0.0/24",
    "10.1.1.0/24",
  ]
}
