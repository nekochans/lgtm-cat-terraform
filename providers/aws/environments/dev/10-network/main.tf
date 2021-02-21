module "vpc" {
  source  = "nekochans/vpc/aws"
  version = "1.0.1"

  name                     = local.name
  env                      = local.env
  azs                      = local.azs
  cidr                     = local.cidr
  public_subnets           = local.public_subnets
  private_subnets          = local.private_subnets
  nat_instance_ami         = local.nat_instance_ami
  nat_instance_type        = local.nat_instance_type
  nat_instance_volume_type = local.nat_instance_volume_type
  nat_instance_volume_size = local.nat_instance_volume_size
}
