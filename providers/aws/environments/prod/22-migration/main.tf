module "migration" {
  source = "../../../../../modules/aws/ecs-migration"

  env            = local.env
  vpc_id         = data.terraform_remote_state.network.outputs.vpc_id
  migration_name = local.migration_name
  db_hostname    = local.db_hostname
  db_name        = local.db_name
  db_password    = local.db_password
  db_username    = local.db_username
}

