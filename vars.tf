
# semua value di variable disimpan di 
# terraform.tfvars (exluded in .gitignore)

# DEFAULT NAME
# ----------------

variable "default_name" {
  description = "Nama default pada tag- untuk keseragaman"
  type        = string
}


# KEYPAIRS
# ----------------

variable "keypairs" {
  description = "keypair yang digunakan untuk mengakses instances"
  type        = string
  sensitive   = true
}

variable "ec2_public_key" {
  description = "ec2 public key, di-generate secara mandiri"
  type        = string
  sensitive   = true
}


# MY PUBLIC IP
# ----------------

variable "myIP" {
  description = "IP public digunakan untuk login SSH"
  type        = string
  sensitive   = true
}


# REGION
# ----------------

variable "region" {
  description = "region yang dipilih, default region Northern Virginia"
  type        = string
  default     = "us-east-1"
}


# VPC MAIN CIDR
# ----------------

variable "vpc_main_cidr_block" {
  description = "block cidr yang ditentukan"
  type        = string
  default     = "10.0.0.0/16"
}


# RDS DB USERNAME AND PASSWORD
# ----------------

variable "db_username" {
  description = "database username for rds instance"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "database password for rds instance"
  type        = string
  sensitive   = true
}




# AWS ACCESS KEY
# ----------------

variable "aws_access_key_id" {
  description = "Access key untuk mengakses API AWS"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "Secret key untuk mengakses API AWS"
  type        = string
  sensitive   = true
}



variable "raw_git" {
  description = "raw git untuk download docker-compose file moodle"
  type        = string
  sensitive   = true
}






# DRAFTS
# ---------------------------------------------------------------

# SUBNETS
# ----------------

# # SUBNETS di AZ-1 (PRIMARY)
# variable "public_subnets" {
#   description = "cidr subnet untuk public ip"
#   # type        = string
#   default     = "10.0.1.0/24"
# }

# variable "private_subnets" {
#   description = "cidr subnet untuk private ip"
#   type        = string
#   default     = "10.0.2.0/24"
# }

# # SUBNETS di AZ-2 (SECONDARY)
# variable "public_subnets_sec" {
#   description = "cidr subnet untuk public ip sec"
#   type        = string
#   default     = "10.0.4.0/24"
# }

# variable "private_subnets_sec" {
#   description = "cidr subnet untuk private ip sec"
#   type        = string
#   default     = "10.0.6.0/24"
# }


# AVAILABILITY ZONES
# ----------------

# variable "availability_zone" {
#   description = "az-primary yang digunakan"
#   type        = string
#   default     = "ap-southeast-3a"
# }

# variable "availability_zone_sec" {
#   description = "az-secondary yang digunakan"
#   type        = string
#   default     = "ap-southeast-3b"
# }

// disabled for future use
# variable "availability_zone_thd" {
#   description = "az-tertiary yang digunakan"
#   default     = "ap-southeast-3c"
# }

