output "api_lambda_securitygroup_id" {
  value = module.lambda.lambda_securitygroup_id
}

output "api_ecs_securitygroup_id" {
  value = module.ecs.ecs_securitygroup_id
}
