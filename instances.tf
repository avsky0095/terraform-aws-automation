
# AWS EC2 INSTANCE DEPLOYMENT
# ---------------------------------------------------------------

resource "aws_instance" "testing-my-ec2" {
  tags = {
      Name                = "test-my-first-ec2"                        # ec2 host
  }

  ami                     = data.aws_ami.ubuntu.id             # Ubuntu 20.04 LTS 64 bit
  instance_type           = "t3.micro"                          # 1 CPU, 2 RAM
  key_name                = var.priv_keypairs                           # aws private key 
  
  availability_zone       = var.availability_zone                        # Northern Virginia, US
  subnet_id               = aws_subnet.publicsubnets.id
  vpc_security_group_ids  = [ aws_security_group.test-ec2-sg.id ]  # Security group rules
  associate_public_ip_address = true        // dynamic public ip yang akan berganti jika di-stop, kemudian dihidupkan lagi
                                            // static public ip, pakai eip

  tenancy                 = "default" // default (shared), dedicated (inst), dedicated host
  monitoring              = true
  ebs_optimized           = true

  ebs_block_device {                                            # Storage device
    device_name           = "/dev/sda1"
    volume_type           = "gp2"                               # General Purpose 2
    volume_size           = 8                                   # 8 GB
    # iops = 0
    # throughput = 0
    # encrypted = true
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits           = "standard"
  }

  user_data = "${file("user-data.txt")}"
 
  # network_interface { // ERROR
  #   network_interface_id  = aws_network_interface.test-netintf-ec2.id
  #   delete_on_termination = true
  #   device_index          = 0
  # }
}

// penempatan ec2 pada subnet publik // ERROR-CONFLICTED
# resource "aws_network_interface" "test-netintf-ec2" {
#   subnet_id = aws_subnet.publicsubnets.id

#   tags = {
#     "Name" = "interface public sub ec2"
#   }
# }



# AWS EC2 SPOT INSTANCE REQUEST
# ---------------------------------------------------------------

resource "aws_spot_instance_request" "test-alpine" {
  tags = {
    Name = "alpine-test-ec2"
    Type = "Spot Request"
  }
  
  ami               = data.aws_ami.alpine.id
  instance_type     = "t3.nano"
  key_name          = var.priv_keypairs
  
  availability_zone = var.availability_zone
  subnet_id         = aws_subnet.privatesubnets.id
  vpc_security_group_ids = [ aws_security_group.privatesub-sg.id ]

  # user_data         = "${file("user-data.txt")}"

  spot_price        = "0.002"
  spot_type         = "one-time"
  wait_for_fulfillment = true

  ebs_block_device {                                            # Storage device
    device_name           = "/dev/sda1"
    volume_type           = "gp2"                               # General Purpose 2
    volume_size           = 5                                   # 8 GB
    # iops = 0
    # throughput = 0
    # encrypted = true
    # delete_on_termination = true
  }

  # connection {
  #   user = "ubuntu"
  #   private_key = "${file("/Users/alen/.ssh/id_rsa")}"
  #   host = "${aws_spot_instance_request.web.public_ip}"
  # }

  // Tag will not be added. Below script will copy tags from spot request to the instance using AWS CLI.
  // https://github.com/terraform-providers/terraform-provider-aws/issues/32

  # provisioner "file" {
  #   source = "set_tags.sh"
  #   destination = "/home/ubuntu/set_tags.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "bash /home/ubuntu/set_tags.sh ${var.access_key} ${var.secret_key} ${var.region} ${aws_spot_instance_request.web.id} ${aws_spot_instance_request.web.spot_instance_id}"
  #   ]
  # }
}
