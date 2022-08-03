
# INSTANCE LISTS
# ----------------
# [Public Subnet I]
# 1. NAT Instance/Bastion Host  (AmazonLinux 2)
#
# [Private Subnet I]
# 1. EC2 test                   (AmazonLinux 2)
# 2. RDS                        (MariaDB)

resource "aws_key_pair" "deployment" {
  key_name    = var.keypairs
  public_key  = var.ec2_public_key

  tags = {
    "Name" = "ec2-local-generated-keypairs"
  }
}

# AWS EC2 INSTANCE DEPLOYMENT ON MANAGEMENT SUBNET
# ---------------------------------------------------------------

# AWS EC2 NAT INSTANCE (PENGGANTI NAT GATEWAY) + BASTION HOST
# ---------------------------------------------------------------

# resource "aws_instance" "nat-bastion" {
#   tags = {
#     "Name" = "NAT Instance / Bastion Host"
#     "Role" = "NAT - Bastion Host"
#   }

#   ami                     = data.aws_ami.ami2.id
#   instance_type           = data.aws_ec2_instance_type_offering.ec2_available.id
#   key_name                = var.keypairs
#   ebs_optimized           = true
#   monitoring              = false

#   // nat instance menggunakan elasticIP (static public IP) di vpc.tf > net_interface
#   // nat instance di-associate pada elasticIP eksisting
#   network_interface {
#     network_interface_id  = aws_network_interface.net-interface.id
#     device_index          = 0
#   }

#   root_block_device {                         # Storage device
#     volume_type           = "gp3"             # General Purpose 2
#     volume_size           = 8
#     iops                  = 3000              # baseline iops
#     throughput            = 125               # baseline throughput (MB/s)
#     # encrypted           = true
#     delete_on_termination = true

#     tags = {
#       "Name" = "rootVol"
#     }
#   }

#   credit_specification {
#     cpu_credits           = "standard"    // standard atau unlimited
#   }

#   # run shell command, entering as ROOT
#   # ipt... (-t)able <nama_table> (-A)ppend POSTR... (-s)ource <IP/mask> (-j)ump target MASQ...
#   user_data = <<EOF
# #!/bin/bash
# yum update -y
# yum install iptables-services -y

# /usr/sbin/sysctl -w net.ipv4.ip_forward=1
# /sbin/iptables -t nat -A POSTROUTING -s '0.0.0.0/0' -j MASQUERADE
# service iptables save
#   EOF
# }


# # AWS EC2 INSTANCE DEPLOYMENT ON PUBLIC SUBNET
# # ---------------------------------------------------------------

# resource "aws_instance" "ec2-on-publicsub" {
#   count = 1               // berapa banyak instance yang akan di-deploy, 0 =  no deploy

#   tags = {
#     Name = "ec2-public-${count.index+1}"                                                      # ec2 host
#   }

#   ami                     = data.aws_ami.ami2.id                              # Amazon Linux 2
#   instance_type           = data.aws_ec2_instance_type_offering.ec2_available.id  # 2 CPU, 1 RAM
#   key_name                = var.keypairs                                 # aws private key
#   availability_zone       = data.aws_availability_zones.az_available.names[0]                             # Jakarta, Indonesia
#   subnet_id               = aws_subnet.publicsubnets[0].id
#   vpc_security_group_ids  = [ aws_security_group.publicsub-sg.id ]             # Security group rules
#   tenancy                 = "default"                                         // default (shared), dedicated (inst), dedicated host
#   ebs_optimized           = true
#   monitoring              = false
# #   iam_instance_profile    = "ecsInstanceRole"

#   root_block_device {                         # Storage device
#     volume_type           = "gp3"             # General Purpose 2
#     volume_size           = 8
#     iops                  = 3000              # baseline iops
#     throughput            = 125               # baseline throughput
#     # encrypted           = true
#     delete_on_termination = true

#     tags = {
#       "Name" = "rootVol-pub-${count.index+1}"
#     }
#   }

#   credit_specification {
#     cpu_credits           = "standard"
#   }

#   # ebs_block_device {                        # Storage device
#   #   device_name           = "/dev/sda1"
#   # }
# }


# # AWS EC2 INSTANCE DEPLOYMENT ON PRIVATE SUBNET
# # ---------------------------------------------------------------

# resource "aws_instance" "ec2-on-privatesub" {
#   count = 1               // berapa banyak instance yang akan di-deploy, 0 =  no deploy

#   tags = {
#     Name = "ec2-private-${count.index+1}"                                                      # ec2 host
#   }

#   ami                     = data.aws_ami.ami2.id                              # Amazon Linux 2
#   instance_type           = data.aws_ec2_instance_type_offering.ec2_available.id  # 2 CPU, 1 RAM
#   key_name                = var.keypairs                                 # aws private key
#   availability_zone       = data.aws_availability_zones.az_available.names[0]                             # Jakarta, Indonesia
#   subnet_id               = aws_subnet.privatesubnets[0].id
#   vpc_security_group_ids  = [ aws_security_group.privatesub-sg.id ]             # Security group rules
#   tenancy                 = "default"                                         // default (shared), dedicated (inst), dedicated host
#   ebs_optimized           = true
#   monitoring              = false

#   root_block_device {                         # Storage device
#     volume_type           = "gp3"             # General Purpose 2
#     volume_size           = 8
#     iops                  = 3000              # baseline iops
#     throughput            = 125               # baseline throughput
#     # encrypted           = true
#     delete_on_termination = true

#     tags = {
#       "Name" = "rootVol-priv-${count.index+1}"
#     }
#   }

#   credit_specification {
#     cpu_credits           = "standard"
#   }

#   # ebs_block_device {                        # Storage device
#   #   device_name           = "/dev/sda1"
#   # }
# }




# # DRAFTS
# # ---------------------------------------------------------------

# // ssh-add <priv-key>
# // ssh -A <user>@ip   >> public dan private


# // disable for future use
# # AWS EC2 SPOT INSTANCE REQUEST (spot instance req / privatesub)
# # ---------------------------------------------------------------

# # # for tagging spot request instances
# # locals {
# #   tags = {
# #     Name = "test-priv-ec2"
# #     Type = "Spot Request"
# #   }
# # }

# # for tagging spot request instances
# # resource "aws_ec2_tag" "priv-ec2" {
# #   resource_id = aws_spot_instance_request.test-priv.spot_instance_id

# #   for_each    = local.tags
# #   key         = each.key
# #   value       = each.value
# # }

# # resource "aws_spot_instance_request" "test-priv" {
# #   ami                     = data.aws_ami.ubuntu.id
# #   instance_type           = data.aws_ec2_instance_type_offering.available.id
# #   key_name                = var.priv_keypairs

# #   availability_zone       = var.availability_zone
# #   subnet_id               = aws_subnet.privatesubnets.id
# #   vpc_security_group_ids  = [ aws_security_group.privatesub-sg.id ]

# #   # associate_public_ip_address = true // tempelkan public ip // tidak digunakan
# #   # user_data         = "${file("user-data.txt")}"

# #   # spot_price              = "0.0042"
# #   spot_type               = "one-time"
# #   wait_for_fulfillment    = true

# #   ebs_block_device {                                            # Storage device
# #     device_name           = "/dev/sda1"
# #     volume_type           = "gp2"                               # General Purpose 2
# #     volume_size           = 10                                   # 8 GB
# #     # iops = 0
# #     # throughput = 0
# #     # encrypted = true
# #     # delete_on_termination = true
# #   }

# #   # connection {
# #   #   user = "ubuntu"
# #   #   private_key = "${file("/Users/alen/.ssh/id_rsa")}"
# #   #   host = "${aws_spot_instance_request.web.public_ip}"
# #   # }

# #   // Tag will not be added. Below script will copy tags from spot request to the instance using AWS CLI.
# #   // https://github.com/terraform-providers/terraform-provider-aws/issues/32

# #   # provisioner "file" {
# #   #   source = "set_tags.sh"
# #   #   destination = "/home/ubuntu/set_tags.sh"
# #   # }

# #   # provisioner "remote-exec" {
# #   #   inline = [
# #   #     "bash /home/ubuntu/set_tags.sh ${var.access_key} ${var.secret_key} ${var.region} ${aws_spot_instance_request.web.id} ${aws_spot_instance_request.web.spot_instance_id}"
# #   #   ]
# #   # }
# # }


# // ubuntu
# #   user_data = <<EOT
# # #!/bin/bash
# # sudo /usr/bin/apt update
# # sudo /usr/bin/apt install ifupdown
# # /bin/echo '#!/bin/bash
# # if [[ $(sudo /usr/sbin/iptables -t nat -L) != *"MASQUERADE"* ]]; then
# #   /bin/echo 1 > /proc/sys/net/ipv4/ip_forward
# #   /usr/sbin/iptables -t nat -A POSTROUTING -s 0.0.0.0/0 -j MASQUERADE
# # fi
# # ' | sudo /usr/bin/tee /etc/network/if-pre-up.d/nat-setup
# # sudo chmod +x /etc/network/if-pre-up.d/nat-setup
# # sudo /etc/network/if-pre-up.d/nat-setup
# #   EOT

# // user data

# # sudo apt update -y
# # sudo apt install -y docker.io docker-compose mysql-client
# # sudo usermod -aG docker ubuntu
# # sudo systemctl enable docker
# # sudo systemctl start docker

# // aws_instance
#   # associate_public_ip_address = true        // dynamic public ip yang akan berganti jika di-stop, kemudian dihidupkan lagi
#                                               // static public ip, pakai eip



#     ## Alpine command iptables forwarding
#     # "doas apk update",
#     # "doas apk add iptables",
#     # "doas sysctl -w net.ipv4.ip_forward=1",
#     # "doas iptables -t nat -A POSTROUTING -s 0.0.0.0/0 -j MASQUERADE",
#     # "doas rc-update add iptables",
#     # "doas /etc/init.d/iptables save"



# #  provisioner "remote-exec" {
# #    inline = [
# #     #AMI command ip forwarding
# #     "yum update -y",
# #     "sudo sysctl -w net.ipv4.ip_forward=1",
# #     "sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE",
# #     "sudo yum install iptables-services -y",
# #     "sudo service iptables save"
# #    ]
# #  }

# #   connection {
# #     agent                 = false
# #     type                  = "ssh"
# #     user                  = "ec2-user"
# #     password              = ""
# #     host                  = "${aws_instance.nat_instance.public_ip}"
# #     # private_key           = file("etc/verifykeys/newkeyaws.pem")                     # lokasi file private key
# #   }



# # yum install docker -y
# # usermod -aG docker ec2-user
# # pip3 install docker-compose
# # systemctl enable docker.service
# # systemctl start docker.service
# # docker version

# # echo PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname) > .env
# # echo RDS_ENDPOINT=${aws_db_instance.rds-test-tf.address} >> .env
# # echo DB_NAME=${aws_db_instance.rds-test-tf.db_name} >> .env
# # echo DB_USER=${var.db_username} >> .env
# # echo DB_PASS=${var.db_password} >> .env
# # echo MDL_USER=${var.db_username} >> .env
# # echo MDL_PASS=${var.db_password} >> .env

# # curl ${var.raw_git} > docker-compose.yml
# # docker-compose up -d




# resource "aws_instance" "ec2-testing" {
#   tags = {
#     "Name" = "ec2-testing"
#   }

#   ami                     = data.aws_ami.ami2.id
#   instance_type           = data.aws_ec2_instance_type_offering.ec2_available.id
#   key_name                = var.keypairs
#   ebs_optimized           = true
#   monitoring              = false
#   availability_zone       = data.aws_availability_zones.az_available.names[0]
#   subnet_id               = aws_subnet.managementsubnet.id
#   vpc_security_group_ids  = [ aws_security_group.ALL-sg.id ]             # Security group rules
  
#   root_block_device {                         # Storage device
#     volume_type           = "gp3"             # General Purpose 3
#     volume_size           = 8
#     iops                  = 3000              # baseline iops
#     throughput            = 125               # baseline throughput (MB/s)
#     # encrypted           = true
#     delete_on_termination = true

#     tags = {
#       "Name" = "rootVol"
#     }
#   }

#   credit_specification {
#     cpu_credits           = "standard"    // standard atau unlimited
#   }

#   user_data = <<EOF
# #!/bin/bash
# yum update -y
# yum install ec2-instance-connect
#   EOF

#   provisioner "local-exec" {
#     command = "aws ec2-instance-connect send-ssh-public-key --region ${var.region} --instance-id ${aws_instance.ec2-testing.id} --availability-zone ${aws_subnet.managementsubnet.availability_zone} --instance-os-user ec2-user --ssh-public-key file://~/.ssh/${var.keypairs}.pub"
#   }
# }
