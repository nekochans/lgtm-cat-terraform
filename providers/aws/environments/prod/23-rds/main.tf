module "rds" {
  source = "../../../../../modules/aws/rds"

  rds_name                    = local.rds_name
  engine                      = local.engine
  engine_version              = local.engine_version
  master_password             = local.master_password
  master_username             = local.master_username
  instance_class              = local.instance_class
  cluster_availability_zones  = local.cluster_availability_zones
  instance_availability_zones = local.instance_availability_zones
  parameter_group_family      = local.parameter_group_family
  vpc_id                      = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids                  = data.terraform_remote_state.network.outputs.subnet_public_ids
  proxy_engine                = local.proxy_engine
  rds_domain_name             = local.rds_domain_name
  rds_proxy_domain_name       = local.rds_proxy_domain_name

  // PROD用
  app_password                   = local.app_password
  app_username                   = local.app_username
  migration_ecs_securitygroup_id = data.terraform_remote_state.migration.outputs.migration_ecs_securitygroup_id
  lambda_securitygroup_id        = data.terraform_remote_state.lambda_securitygroup.outputs.lambda_security_group_id
  api_lambda_securitygroup_id    = data.terraform_remote_state.api.outputs.api_lambda_securitygroup_id
  api_ecs_securitygroup_id       = data.terraform_remote_state.api.outputs.api_ecs_securitygroup_id

  // STG用
  stg_app_password                   = local.stg_app_password
  stg_app_username                   = local.stg_app_username
  stg_migration_ecs_securitygroup_id = data.terraform_remote_state.stg_migration.outputs.migration_ecs_securitygroup_id
  stg_lambda_securitygroup_id        = data.terraform_remote_state.stg_lambda_securitygroup.outputs.lambda_security_group_id
  stg_api_lambda_securitygroup_id    = data.terraform_remote_state.stg_api.outputs.api_lambda_securitygroup_id
  stg_api_ecs_securitygroup_id       = data.terraform_remote_state.stg_api.outputs.api_ecs_securitygroup_id
}
