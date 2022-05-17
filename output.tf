output "ec2_public_dns" {
  description             = "List of public DNS addresses assigned to the instances, if applicable"
  value                   = [aws_instance.testing-my-ec2.public_dns]
#   value                   = [aws_spot_instance_request.CheapWorker.public_dns]
}