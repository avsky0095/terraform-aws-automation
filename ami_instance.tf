
# EC2 AMI
# ---------------------------------------------------------------

# UBUNTU

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical
}


# ALPINE

data "aws_ami" "alpine" {
  most_recent = true

  filter {
    name   = "name"
    values = ["alpine-3.16.0-x86_64-bios-tiny-r0"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["538276064493"] # Alpine
}


# AMAZON LINUX 2

data "aws_ami" "ami2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20220426.0-x86_64-gp2"]
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



# MOODLE BITNAMI

data "aws_ami" "moodle" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-moodle-4.0.1-2-r02-linux-debian-10-x86_64-hvm-ebs-nami-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["786482375130"]
}


# WORDPRESS BITNAMI

data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name   = "name"
    values = ["openlitespeed-wordpress-v24-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["786482375130"]
}


data "aws_ec2_instance_type_offering" "available" {
  filter {
    name   = "instance-type"
    values = ["t3.micro"]                   //arrays
  }

  preferred_instance_types = ["t3.micro"]
}




// search owner number di EC2 > side panel Images - AMIs > pilih Public AMI 


data "aws_instances" "NAT-instance" {
  instance_tags = {
    # Name = "NAT instance"
    Role = "nat"
  }

  # filter {
  #   name   = "instance.group-id"
  #   values = ["sg-12345678"]
  # }

  instance_state_names = ["running"]
}