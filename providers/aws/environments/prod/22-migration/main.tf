module "migration" {
  source = "../../../../../modules/aws/ecs-migration"

  vpc_id         = data.terraform_remote_state.network.outputs.vpc_id
  migration_name = local.migration_name
}

