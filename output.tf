
// disabled for future use
# output "ec2_public_dns" {
#   description             = "List of public DNS addresses assigned to the instances, if applicable"
#   value                   = [aws_instance.testing-my-ec2.public_dns]
# }

output "ec2_NATinst_public_dns" {
  description             = "List of public DNS addresses assigned to the instances, if applicable"
  value                   = [aws_instance.nat_instance.public_dns]
}

output "ec2_private_ip" {
  description             = "List of public DNS addresses assigned to the instances, if applicable"
  value                   = [aws_spot_instance_request.test-priv.private_ip]
}