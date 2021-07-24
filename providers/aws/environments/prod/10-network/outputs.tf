output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_public_ids" {
  value = module.vpc.subnet_public_ids
}
