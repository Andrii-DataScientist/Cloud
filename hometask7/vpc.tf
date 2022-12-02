# resource "aws_vpc" "dev" {
#   cidr_block           = "10.0.0.0/16"
#   instance_tenancy     = "default"
#   enable_dns_support   = "true"
#   enable_dns_hostnames = "true"
#   enable_classiclink   = "false"
#   tags = {
#     Name = "dev"
#   }
# }

# resource "aws_subnet" "dev-public-1" {
#   vpc_id                  = aws_vpc.dev.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1"

#   tags = {
#     Name = "dev-public-1"
#   }
# }

# resource "aws_subnet" "dev-public-2" {
#   vpc_id                  = aws_vpc.dev.id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1"

#   tags = {
#     Name = "dev-public-2"
#   }
# }

# # Creating Internet Gateway in AWS VPC
# resource "aws_internet_gateway" "dev-gw" {
#   vpc_id = aws_vpc.dev.id

#   tags = {
#     Name = "dev"
#   }
# }

# # Creating Route Tables for Internet gateway
# resource "aws_route_table" "dev-public" {
#   vpc_id = aws_vpc.dev.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.dev-gw.id
#   }

#   tags = {
#     Name = "dev-public-1"
#   }
# }

# # Creating Route Associations public subnets
# resource "aws_route_table_association" "dev-public-1-a" {
#   subnet_id      = aws_subnet.dev-public-1.id
#   route_table_id = aws_route_table.dev-public.id
# }

# resource "aws_route_table_association" "dev-public-2-a" {
#   subnet_id      = aws_subnet.dev-public-2.id
#   route_table_id = aws_route_table.dev-public.id
# }



# resource "aws_network_acl" "dev-acl" {
#   vpc_id = aws_vpc.dev.id
#   subnet_ids = [aws_subnet.dev-public-1.id, aws_subnet.dev-public-2.id]
#   egress {
#     protocol   = "tcp"
#     rule_no    = 1
#     action     = "deny"
#     cidr_block = "50.31.252.0/24"
#     from_port  = 80
#     to_port    = 80
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "deny"
#     cidr_block = "50.31.252.0/24"
#     from_port  = 80
#     to_port    = 80
#   }

#   tags = {
#     Name = "main"
#   }
# }
