module "rds" {
  source = "../../../../../modules/aws/rds"

  rds_name                       = local.rds_name
  engine                         = local.engine
  engine_version                 = local.engine_version
  master_password                = local.master_password
  master_username                = local.master_username
  instance_class                 = local.instance_class
  cluster_availability_zones     = local.cluster_availability_zones
  instance_availability_zones    = local.instance_availability_zones
  parameter_group_family         = local.parameter_group_family
  vpc_id                         = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids                     = data.terraform_remote_state.network.outputs.subnet_public_ids
  proxy_engine                   = local.proxy_engine
  app_password                   = local.app_password
  app_username                   = local.app_username
  stg_lambda_securitygroup_id    = data.terraform_remote_state.stg_lambda_securitygroup.outputs.lambda_security_group_id
  migration_ecs_securitygroup_id = data.terraform_remote_state.migration.outputs.migration_ecs_securitygroup_id
  rds_domain_name                = local.rds_domain_name
  rds_proxy_domain_name          = local.rds_proxy_domain_name
}