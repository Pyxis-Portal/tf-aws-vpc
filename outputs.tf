output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "vpc_private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "vpc_public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "vpc_public_subnets_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "vpc_environment" {
  value = var.environment
}

output "vpc_aws_region" {
  value = var.aws_region
}

output "project_name" {
  value = var.project_name
}

//output "sqs_url_endpoint" {
//  value = aws_vpc_endpoint.sqs[0].dns_entry
//}
