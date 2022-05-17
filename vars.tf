
# REGION USE
variable "region" {}

# AVAILABILITY ZONE
variable "availability_zone" {}
variable "availability_zone_sec" {}

# VPC IPs
variable "main_vpc_cidr" {}

# SUBNETS
variable "public_subnets" {}
variable "private_subnets" {}

# MY PUBLIC IP
variable "myIP" {}

# Keypairs
variable "priv_keypairs" {}

# AWS ACCESS KEY
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}