variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Nombre del ambiente. e.g, dev, qa, stg, prod"
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "project_name" {
  type    = string
  default = "my-project"
}

variable "project_vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "vpc_enable_s3_endpoint" {
  type    = bool
  default = false
}

variable "vpc_enable_sqs_endpoint" {
  type    = bool
  default = false
}

variable "vpc_enable_sts_endpoint" {
  type    = bool
  default = false
}

variable "vpc_enable_dynamodb_endpoint" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "cidr_subnet_bits" {
  type    = number
  default = 3
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "general tags"
}

variable "private_subnets" {
  type = list(string)
  default = []
  description = "List of cidrs for subnets"
}

variable "public_subnets" {
  type = list(string)
  default = []
  description = "List of cidrs for subnets"
}

variable "enable_nat_gateway" {
  type = bool
  default = false
  description = "Whether to enable Nat Gateway. If private_subnets list is empty, this should"
}

variable vpc_endpoint {
  type        = any
  default     = []
  description = "description"
}

variable vpc_enable_endpoint {
  type        = bool
  default     = false 
  description = "description"
}

variable ec2_sg_ingress_rules {
  type        = any
  default     = []
  description = "description"
}

variable ec2_sg_egress_rules {
  type        = any
  default     = []
  description = "description"
}
