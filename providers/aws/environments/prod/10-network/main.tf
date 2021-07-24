module "vpc" {
  source = "../../../../../modules/aws/vpc"

  name           = local.name
  azs            = local.azs
  cidr           = local.cidr
  public_subnets = local.public_subnets
}
