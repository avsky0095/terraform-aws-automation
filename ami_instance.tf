
# EC2 AMI
# ---------------------------------------------------------------

# UBUNTU

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images-testing/hvm-ssd/ubuntu-jammy-daily-amd64-minimal-*"]
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
    values = ["alpine-3.15.4-x86_64-bios-tiny-r0"]
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