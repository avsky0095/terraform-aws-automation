
# REGION USE
variable "region" {
  description = "region yang dipilih"
}

# AVAILABILITY ZONEs
variable "availability_zone" {
  description = "az-primary yang digunakan"
}

variable "availability_zone_sec" {
  description = "az-secondary yang digunakan"
}

# VPC IPs
variable "main_vpc_cidr" {
  description = "block cidr yang ditentukan"
}

# SUBNETS
variable "public_subnets" {
  description = "cidr subnet untuk public ip"
}

variable "private_subnets" {
  description = "cidr subnet untuk private ip"
}

# SUBNETS SECONDARY
variable "public_subnets_sec" {
  description = "cidr subnet untuk public ip sec"
}

variable "private_subnets_sec" {
  description = "cidr subnet untuk private ip sec"
}


# SECURITY GROUP INGRESS CIDR FOR NAT-INSTANCE
# variable "security_group_ingress_cidr_ipv4" {
#   description = "CIDR block ingress nat-sg"
# }

# MY PUBLIC IP
variable "myIP" {
  description = "IP public saya"
}

# Keypairs
variable "priv_keypairs" {
  description = "keypair yang digunakan untuk mengakses instances"
}

# AWS ACCESS KEY
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}



# variable "availability_zone_sec" {}
# variable "public_subnets_sec" {}
