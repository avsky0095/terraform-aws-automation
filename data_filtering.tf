
# AVAILABILITY ZONES FILTERING
# ---------------------------------------------------------------

# list az tergantung region yang diset di providers.tf > region
# list ada di vars.tf
data "aws_availability_zones" "az_available" {
  state     = "available"
  
  # filter {
  #   name    = "zone-name"
  #   values  = ["ap-southeast-3a", "ap-southeast-3b", "ap-southeast-3c",]
  # #             0                   1                 2
  # }
}


# EC2 AMI
# ---------------------------------------------------------------

# Memilih instance type rekomendasi dan yang prefer
data "aws_ec2_instance_type_offering" "ec2_available" {
  filter {
    name                    = "instance-type"
    values                  = ["t3.micro", "t3.nano", "t3.small"]   // filtering instance type yang ada
  }

  preferred_instance_types  = ["t3.micro", "t3.nano", "t3.small"]   // dicari secara berurutan kalau available
}


# RDS OFFERING
# ---------------------------------------------------------------

# Memilih instance type untuk database RDS
data "aws_rds_orderable_db_instance" "rds_available" {
  engine                      = "mariadb"
  engine_version              = "10.6.7"
  instance_class              = "db.${data.aws_ec2_instance_type_offering.ec2_available.id}"
  storage_type                = "gp2"
  license_model               = "general-public-license"
  vpc                         = true
  
  # preferred_engine_versions   = ["10.6.7"]
  # preferred_instance_classes  = ["db.t3.micro", "db.t2.micro"]
}


# AMAZON LINUX 2
# ----------------

data "aws_ami" "ami2" {
  most_recent = true

  filter {
    name   = "description"
    values = ["Amazon Linux 2 AMI*"]
  }
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*", "*-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["785737495101"]
}



# DRAFTS
# ---------------------------------------------------------------



# CENTRALIZE AZ AND CIDR BLOCKS
# ----------------

# locals {                    // data az di data_filtering.tf
#   availability_zone_1     = data.aws_availability_zones.az_available.names[0]   # a
#   availability_zone_2     = data.aws_availability_zones.az_available.names[1]   # b
#   availability_zone_3     = data.aws_availability_zones.az_available.names[2]   # c

#   // create vpc subnet dengan command terraform "cidrsubnet"
#   pubsub_prim_cidrblock   = cidrsubnet(aws_vpc.Main.cidr_block, 8, 1) # 10.0.0.0/16 + 8 (=/24) , network ke berapa (looping)
#   privsub_prim_cidrblock  = cidrsubnet(aws_vpc.Main.cidr_block, 8, 2)   # network 0-255          mulai dari network 0
#   pubsub_sec_cidrblock    = cidrsubnet(aws_vpc.Main.cidr_block, 8, 3)
#   privsub_sec_cidrblock   = cidrsubnet(aws_vpc.Main.cidr_block, 8, 4) # .1.0, .2.0, dst
# }

# UBUNTU
# ----------------

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   owners = ["099720109477"] # Canonical
# }


# ALPINE
# ----------------

# data "aws_ami" "alpine" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["alpine-3.16.0-x86_64-bios-tiny-r0"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   owners = ["538276064493"] # Alpine
# }



# MOODLE BITNAMI

# data "aws_ami" "moodle" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["bitnami-moodle-4.0.1-2-r02-linux-debian-10-x86_64-hvm-ebs-nami-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   owners = ["786482375130"]
# }


# WORDPRESS BITNAMI

# data "aws_ami" "wordpress" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["openlitespeed-wordpress-v24-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   owners = ["786482375130"]
# }



// search owner number di EC2 > side panel Images - AMIs > pilih Public AMI 



// lupa ini buat apa?
# data "aws_instances" "NAT-instance" {
#   instance_tags = {
#     # Name = "NAT instance"
#     Role = "nat"
#   }

#   # filter {
#   #   name   = "instance.group-id"
#   #   values = ["sg-12345678"]
#   # }

#   instance_state_names = ["running"]
# }