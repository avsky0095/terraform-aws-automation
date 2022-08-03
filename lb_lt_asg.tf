
# # CREATE LOAD BALANCER
# # ---------------------------------------------------------------

# resource "aws_lb" "test-loadbalancer" {
#   name                       = "test-loadbalancer"
#   internal                   = false // internet-facing
#   load_balancer_type         = "application"
#   security_groups            = [ aws_security_group.lb-sg.id ]
#   subnets                    = [ for subnet in aws_subnet.publicsubnets : subnet.id ]
#   enable_deletion_protection = false

# #   access_logs {
# #   }

#   tags = {
#     "Name" = "AppLoadBalancer test"
#   }
# }


# resource "aws_lb_listener" "lb-listener-test" {
#   load_balancer_arn     = aws_lb.test-loadbalancer.arn
#   port                  = 80
#   protocol              = "HTTP"

#   default_action {
#     type                = "forward"
#     target_group_arn    = aws_lb_target_group.lb-targetgrp.arn
#   }

#   tags = {
#     Name = "test-lb-listener"
#   }
# }

# resource "aws_lb_target_group" "lb-targetgrp" {
#   name          = "test-lb-targetgroup"
#   port          = 80
#   protocol      = "HTTP"
#   target_type   = "instance"
#   vpc_id        = aws_vpc.Main.id

#   tags = {
#     "Name" = "lb-tg-test"
#   }
# }

# resource "aws_autoscaling_attachment" "lb-asg-attach" {
#   autoscaling_group_name = aws_autoscaling_group.test-asg.id
#   lb_target_group_arn    = aws_lb_target_group.lb-targetgrp.arn
# }


# # CREATE AUTOSCALING GROUP + POLICY
# # ---------------------------------------------------------------

# resource "aws_autoscaling_group" "test-asg" {
#   name                      = "testing my launch template"

# #   vpc_zone_identifier       = [ aws_subnet.privatesubnets[0].id, aws_subnet.privatesubnets[1].id ]
#   vpc_zone_identifier       = [ for subnet in aws_subnet.privatesubnets : subnet.id  ]
  
#   health_check_type         = "ELB"
#   health_check_grace_period = 30
#   desired_capacity          = 1
#   min_size                  = 1
#   max_size                  = 2
#   force_delete              = false

#   launch_template {
#     id      = aws_launch_template.test-launchtemplate.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "Name"
#     value               = "asg-test"
#     propagate_at_launch = true
#   }

# }

# # resource "aws_autoscaling_policy" "as-policy" {
# #   name                   = "autoscaling-policy"
# #   autoscaling_group_name = aws_autoscaling_group.test-asg.name
# #   policy_type            = "PredictiveScaling"

# #   predictive_scaling_configuration {
# #     metric_specification {
# #       target_value = 80

# #       customized_scaling_metric_specification {

# #         metric_data_queries {
# #           id = "scaling"

# #           metric_stat {

# #             metric {

# #               metric_name = "CPUUtilization"
# #               namespace   = "AWS/EC2"

# #               dimensions {
# #                 name  = "AutoScalingGroup"
# #                 value = "test-asg-now"
# #               }
# #             }

# #             stat = "Average"
# #           }
# #         }
# #       }
# #     }
# #   }
# # }


# # CREATE LAUNCH TEMPLATE
# # ---------------------------------------------------------------

# resource "aws_launch_template" "test-launchtemplate" {
#   name                      = "test-launchtemplate"
#   image_id                  = data.aws_ami.ami2.id
#   instance_type             = data.aws_ec2_instance_type_offering.ec2_available.id
#   description               = "Testing launch template"
#   key_name                  = var.keypairs
#   vpc_security_group_ids    = [ aws_security_group.privatesub-sg.id ]
  
#   block_device_mappings {
#     device_name = "/dev/xvda" // dev/xvda1 -> xvda default RHEL-based ROOT block storage name 
#                               // jika pakai xvd[x] akan enlarge root storage, sebaliknya /dev/sd[x]
#     ebs {
#       volume_size = 10
#       volume_type = "gp3"
#       iops        = 3000    // baseline iops gp3
#       throughput  = 125     // baseline throughput
#     }
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       "Key"   = "Name"
#       "Value" = "test-ec2-lt"
#     }
#   }

# #   user_data = <<USERDATA
# # #!/bin/bash

# # touch .env
# # echo PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname) > .env

# # echo "[INSTALL] Docker dan Docker Compose"

# # sudo apt update -y
# # sudo apt install -y docker.io docker-compose
# # sudo usermod -aG docker ubuntu
# # sudo systemctl enable docker
# # sudo systemctl start docker
# #   USERDATA

#   #   network_interfaces {
#   #     # security_groups = [aws_security_group.privatesub-sg.id]
#   #     subnet_id       = aws_subnet.privatesubnets.id
#   #     device_index    = 1
#   #   }

#   #   instance_market_options {
#   #     market_type = "spot"

#   #     spot_options {
#   #       spot_instance_type             = "one-time"
#   #       instance_interruption_behavior = "terminate"
#   #     }
#   #   }

#   #   placement {
#   #     availability_zone = var.availability_zone
#   #     tenancy = "default"
#   #   }

#   #   private_dns_name_options {
#   #     hostname_type = "ip-name"
#   #   }

# }
