

# output "ec2_eip_NATBas_public_dns" {
#   description = "Output NAT instance public DNS"
#   value       = aws_instance.nat-bastion.public_dns        // public_ip/_dns/private_ip/_dns
# }

# # output "rds_hostname" {
# #   description = "RDS instance hostname"
# #   value       = aws_db_instance.rds-test-tf.address
# #   # sensitive   = true
# # }

# output "elb-dns-name" {
#   description = "dns dari elb"
#   value       = aws_lb.test-loadbalancer.dns_name
# }