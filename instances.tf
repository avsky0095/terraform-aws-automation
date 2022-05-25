
# AWS EC2 INSTANCE DEPLOYMENT
# ---------------------------------------------------------------

// disable for future use
# resource "aws_instance" "testing-my-ec2" {
#   tags = {
#       Name                = "test-ec2"                        # ec2 host
#   }

#   ami                     = data.aws_ami.ubuntu.id             # Ubuntu 20.04 LTS 64 bit
#   instance_type           = data.aws_ec2_instance_type_offering.available.id                          # 1 CPU, 2 RAM
#   key_name                = var.priv_keypairs                           # aws private key 
  
#   availability_zone       = var.availability_zone                        # Northern Virginia, US
#   subnet_id               = aws_subnet.publicsubnets.id
#   vpc_security_group_ids  = [ aws_security_group.publicsub-sg.id ]  # Security group rules
#   # associate_public_ip_address = true        // dynamic public ip yang akan berganti jika di-stop, kemudian dihidupkan lagi
#                                             // static public ip, pakai eip

#   tenancy                 = "default" // default (shared), dedicated (inst), dedicated host
#   monitoring              = true
#   ebs_optimized           = true

#   ebs_block_device {                                            # Storage device
#     device_name           = "/dev/sda1"
#     volume_type           = "gp2"                               # General Purpose 2
#     volume_size           = 8                                   # 8 GB
#     # iops = 0
#     # throughput = 0
#     # encrypted = true
#     delete_on_termination = true
#   }

#   credit_specification {
#     cpu_credits           = "standard"
#   }

#   user_data = "${file("user-data.txt")}"
# }


# AWS EC2 SPOT INSTANCE REQUEST (spot instance req / privatesub)
# ---------------------------------------------------------------

# for tagging spot request instances
locals {
  tags = {
    Name = "test-pub-ec2"
    Type = "Spot Request"
  }  
}

# for tagging spot request instances
resource "aws_ec2_tag" "priv-ec2" {
  resource_id = aws_spot_instance_request.test-priv.spot_instance_id

  for_each    = local.tags
  key         = each.key
  value       = each.value
}

resource "aws_spot_instance_request" "test-priv" {  
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = data.aws_ec2_instance_type_offering.available.id 
  key_name                = var.priv_keypairs
  
  availability_zone       = var.availability_zone
  subnet_id               = aws_subnet.privatesubnets.id
  vpc_security_group_ids  = [ aws_security_group.privatesub-sg.id ]

  # associate_public_ip_address = true // tempelkan public ip // tidak digunakan
  # user_data         = "${file("user-data.txt")}"

  # spot_price              = "0.0042"
  spot_type               = "one-time"
  wait_for_fulfillment    = true

  ebs_block_device {                                            # Storage device
    device_name           = "/dev/sda1"
    volume_type           = "gp2"                               # General Purpose 2
    volume_size           = 8                                   # 8 GB
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

// ssh-add <priv-key>
// ssh -A <user>@ip   >> public dan private



# AWS EC2 NAT INSTANCE (PENGGANTI NAT GATEWAY) + BASTION HOST
# ---------------------------------------------------------------

resource "aws_instance" "nat_instance" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = data.aws_ec2_instance_type_offering.available.id
  key_name                = var.priv_keypairs
  # count                  = 1

  network_interface {
    network_interface_id  = aws_network_interface.net-interface.id
    device_index          = 0
  }
  
  ebs_block_device {                                            # Storage device
    device_name           = "/dev/sda1"
    volume_type           = "gp2"                               # General Purpose 2
    volume_size           = 8
  }

  // forwarding route dari private ke NAT-instance
  user_data = <<EOT
#!/bin/bash
sudo /usr/bin/apt update
sudo /usr/bin/apt install ifupdown
/bin/echo '#!/bin/bash
if [[ $(sudo /usr/sbin/iptables -t nat -L) != *"MASQUERADE"* ]]; then
  /bin/echo 1 > /proc/sys/net/ipv4/ip_forward
  /usr/sbin/iptables -t nat -A POSTROUTING -s ${var.security_group_ingress_cidr_ipv4} -j MASQUERADE
fi
' | sudo /usr/bin/tee /etc/network/if-pre-up.d/nat-setup
sudo chmod +x /etc/network/if-pre-up.d/nat-setup
sudo /etc/network/if-pre-up.d/nat-setup 
  EOT

  tags = {
    "Name" = "NAT instance"
    "Role" = "nat"
  }
}