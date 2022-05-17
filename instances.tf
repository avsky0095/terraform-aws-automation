
# AWS EC2 INSTANCE DEPLOYMENT
# ---------------------------------------------------------------

resource "aws_instance" "testing-my-ec2" {
  tags = {
      Name                = "ec2-moodle"                        # ec2 host
  }

  ami                     = "ami-09e67e426f25ce0d7"             # Ubuntu 20.04 LTS 64 bit
  instance_type           = "t3.small"                          # 1 CPU, 2 RAM
  key_name                = "newkeyaws"                           # aws private key 
  vpc_security_group_ids  = [aws_security_group.test-ec2-sg.id]  # Security group rules
  availability_zone       = "ap-southeast-3a"                        # Northern Virginia, US

  monitoring = true
  tenancy = "default" // default (shared), dedicated (inst), dedicated host
  ebs_optimized = true

  network_interface {
    network_interface_id = aws_network_interface.test-netintf-ec2.id
    device_index = 0
  }

  ebs_block_device {                                            # Storage device
    device_name           = "/dev/sda1"
    volume_type           = "gp2"                               # General Purpose 2
    volume_size           = 8                                   # 8 GB
    # iops = 0
    # throughput = 0
    delete_on_termination = true
    # encrypted = true
  }

  credit_specification {
    cpu_credits           = "standard"
  }

  # user_data = var.user_data
}

// penempatan ec2 pada subnet publik
resource "aws_network_interface" "test-netintf-ec2" {
  subnet_id = aws_subnet.publicsubnets.id

  tags = {
    "Name" = "interface public sub ec2"
  }
}
