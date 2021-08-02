module "lambda" {
  source = "../../../../../modules/aws/lambda-securitygroup"

  vpc_id               = data.terraform_remote_state.network.outputs.vpc_id
  lambda_function_name = local.lambda_function_name
}

