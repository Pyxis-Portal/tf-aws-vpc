locals {

  tags = {
    Terraform   = true
    Environment = var.environment
  }
}

data "aws_vpc_endpoint_service" "dynamodb" {
  count = var.vpc_enable_dynamodb_endpoint ? 1 : 0

  service = "dynamodb"
}

data "aws_vpc_endpoint_service" "sqs" {
  count = var.vpc_enable_sqs_endpoint ? 1 : 0

  service = "sqs"
}

data "aws_vpc_endpoint_service" "sts" {
  count = var.vpc_enable_sts_endpoint ? 1 : 0

  service = "sts"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "2.70.0"

  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_sqs_endpoint    = false
  single_nat_gateway     = var.single_nat_gateway
  enable_s3_endpoint     = var.vpc_enable_s3_endpoint
  name                   = var.vpc_name != "" ? var.vpc_name : "${var.environment}-${var.project_name}-vpc"
  cidr                   = var.project_vpc_cidr
  azs                    = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c", "${var.aws_region}d"]

  private_subnets = [
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 0),
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 1),
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 2),
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 3)
  ]

  public_subnets = [
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 4),
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 5),
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 6),
    cidrsubnet(var.project_vpc_cidr, var.cidr_subnet_bits, 7)
  ]

  private_subnet_tags = {
    Name = var.vpc_name != "" ? "${var.vpc_name}-private-subnet" : "${var.environment}-private-${var.project_name}-subnet"
  }

  public_subnet_tags = {
    Name = var.vpc_name != "" ? "${var.vpc_name}-public-subnet" : "${var.environment}-public-${var.project_name}-subnet"
  }

  tags = merge(
    local.tags,
    {
      Name                               = var.vpc_name != "" ? var.vpc_name : "${var.environment}-${var.project_name}-vpc"
      "kubernetes.io/cluster/my-cluster" = "shared"
    },
  ) 
}

resource "aws_security_group" "sqs_vpc_endpoint_security_group" {
  count       = var.vpc_enable_sqs_endpoint ? 1 : 0
  depends_on  = [module.vpc]
  name        = "${var.environment}-${var.project_name}-vpc-e-sqs"
  description = "Controls Traffic to the AWS SQS VPC Endpoint"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "${var.environment}-${var.project_name}-vpc-e-sqs"
    }
  ) 
}

resource "aws_vpc_endpoint" "sqs" {
  count = var.vpc_enable_sqs_endpoint ? 1 : 0

  vpc_id            = module.vpc.vpc_id
  service_name      = data.aws_vpc_endpoint_service.sqs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.sqs_vpc_endpoint_security_group[0].id]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = false
}

resource "aws_security_group" "sts_vpc_endpoint_security_group" {
  count       = var.vpc_enable_sts_endpoint ? 1 : 0
  depends_on  = [module.vpc]
  name        = "${var.environment}-${var.project_name}-vpc-e-sts"
  description = "Controls Traffic to the AWS STS VPC Endpoint"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "${var.environment}-${var.project_name}-vpc-e-sts"
    }
  ) 
}

resource "aws_vpc_endpoint" "sts" {
  count = var.vpc_enable_sts_endpoint ? 1 : 0

  vpc_id            = module.vpc.vpc_id
  service_name      = data.aws_vpc_endpoint_service.sts[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.sts_vpc_endpoint_security_group[0].id]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = false
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.vpc_enable_dynamodb_endpoint && length(data.aws_vpc_endpoint_service.dynamodb) == 0 ? 1 : 0

  vpc_id              = module.vpc.vpc_id
  service_name        = data.aws_vpc_endpoint_service.dynamodb[0].service_name
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false
}