locals {

  tags = {
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

  version = "2.71.0"

  enable_nat_gateway     = var.enable_nat_gateway && length(var.private_subnets) > 0 ? true : false
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_sqs_endpoint    = false
  single_nat_gateway     = var.single_nat_gateway
  enable_s3_endpoint     = var.vpc_enable_s3_endpoint
  name                   = var.vpc_name != "" ? var.vpc_name : "${var.environment}-${var.project_name}-vpc"
  cidr                   = var.project_vpc_cidr
  azs                    = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets

  private_subnet_tags = {
    Name = var.vpc_name != "" ? "${var.vpc_name}-private-subnet" : "${var.environment}-private-${var.project_name}-subnet"
  }

  public_subnet_tags = {
    Name = var.vpc_name != "" ? "${var.vpc_name}-public-subnet" : "${var.environment}-public-${var.project_name}-subnet"
  }

  tags = merge(
    local.tags,
    var.tags,
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
    var.tags,
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
    var.tags,
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

resource "aws_vpc_endpoint" "this" {
  count = var.vpc_enable_endpoint ? length(var.vpc_endpoint) : 0

  service_name = var.vpc_endpoint[count.index].service_name
  vpc_id       = module.vpc.vpc_id

  vpc_endpoint_type  = lookup(var.vpc_endpoint[count.index], "type", "Gateway")
  security_group_ids = lookup(var.vpc_endpoint[count.index], "security_group", false) ? lookup(var.vpc_endpoint[count.index], "security_group_ids", [aws_security_group.vpc_endpoint_security_group[0].id]) : null
  subnet_ids         = lookup(var.vpc_endpoint[count.index], "subnet_ids", module.vpc.private_subnets)
  #dns_options        = lookup(var.vpc_endpoint[count.index], "dns_options", null)
  #ip_address_type    = lookup(var.vpc_endpoint[count.index], "ip_address_type", null)
  route_table_ids    = lookup(var.vpc_endpoint[count.index], "type", "Gateway") == "Gateway" ? lookup(var.vpc_endpoint[count.index], "route_table_ids", module.vpc.private_route_table_ids) : null
  policy             = lookup(var.vpc_endpoint[count.index], "policy", null)


  private_dns_enabled = lookup(var.vpc_endpoint[count.index], "private_dns_enabled", false)


  tags = merge(
    local.tags,
    var.tags,
    {
      Name = "${var.environment}-${var.project_name}-vpc-e-${lookup(var.vpc_endpoint[count.index], "name", "")}"
    }
  )
}

resource "aws_security_group" "vpc_endpoint_security_group" {
  count       = var.vpc_enable_endpoint && length(var.ec2_sg_ingress_rules) > 0 || length(var.ec2_sg_egress_rules) > 0 ? 1 : 0
  name        = "${var.environment}-${var.project_name}-vpc-SG"
  description = "Controls Traffic to the AWS VPC Endpoint"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.ec2_sg_ingress_rules

    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      cidr_blocks = ingress.value["cidr_blocks"]
      protocol    = ingress.value["protocol"]
    }
  }

  dynamic "egress" {
    for_each = var.ec2_sg_egress_rules

    content {
      description = egress.value["description"]
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      cidr_blocks = egress.value["cidr_blocks"]
      protocol    = egress.value["protocol"]
    }
  }

  depends_on = [module.vpc]

  tags = merge(
    local.tags,
    var.tags,
    {
      Name = "${var.environment}-${var.project_name}-vpc-SG"
    }
  )
}
