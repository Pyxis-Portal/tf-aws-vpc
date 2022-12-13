## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.10 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 2.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 2.71.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.sqs_vpc_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sts_vpc_endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_service.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_cidr_subnet_bits"></a> [cidr\_subnet\_bits](#input\_cidr\_subnet\_bits) | n/a | `number` | `3` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Nombre del ambiente. e.g, dev, qa, stg, prod | `string` | `"dev"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | `"my-project"` | no |
| <a name="input_project_vpc_cidr"></a> [project\_vpc\_cidr](#input\_project\_vpc\_cidr) | n/a | `string` | `"10.10.0.0/16"` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | n/a | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | general tags | `map(string)` | `{}` | no |
| <a name="input_vpc_enable_dynamodb_endpoint"></a> [vpc\_enable\_dynamodb\_endpoint](#input\_vpc\_enable\_dynamodb\_endpoint) | n/a | `bool` | `false` | no |
| <a name="input_vpc_enable_s3_endpoint"></a> [vpc\_enable\_s3\_endpoint](#input\_vpc\_enable\_s3\_endpoint) | n/a | `bool` | `false` | no |
| <a name="input_vpc_enable_sqs_endpoint"></a> [vpc\_enable\_sqs\_endpoint](#input\_vpc\_enable\_sqs\_endpoint) | n/a | `bool` | `false` | no |
| <a name="input_vpc_enable_sts_endpoint"></a> [vpc\_enable\_sts\_endpoint](#input\_vpc\_enable\_sts\_endpoint) | n/a | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | n/a |
| <a name="output_vpc_aws_region"></a> [vpc\_aws\_region](#output\_vpc\_aws\_region) | n/a |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | n/a |
| <a name="output_vpc_environment"></a> [vpc\_environment](#output\_vpc\_environment) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#output\_vpc\_private\_subnet\_ids) | n/a |
| <a name="output_vpc_private_subnets_cidr_blocks"></a> [vpc\_private\_subnets\_cidr\_blocks](#output\_vpc\_private\_subnets\_cidr\_blocks) | n/a |
| <a name="output_vpc_public_subnet_ids"></a> [vpc\_public\_subnet\_ids](#output\_vpc\_public\_subnet\_ids) | n/a |
| <a name="output_vpc_public_subnets_cidr_blocks"></a> [vpc\_public\_subnets\_cidr\_blocks](#output\_vpc\_public\_subnets\_cidr\_blocks) | n/a |
