

# # inventarisasi daftar subnet dalam vpc
# resource "aws_db_subnet_group" "rds_def_subnetgroup" {
#   name        = "main"
#   subnet_ids  = [ for subnet in aws_subnet.privatesubnets : subnet.id  ]

#   tags = {
#     "Name" = "RDS DB subnet group"
#   }
# }

# resource "aws_db_instance" "rds-test-tf" {
#   engine                 = data.aws_rds_orderable_db_instance.rds_available.engine
#   engine_version         = data.aws_rds_orderable_db_instance.rds_available.engine_version
#   instance_class         = data.aws_rds_orderable_db_instance.rds_available.instance_class
  
#   identifier             = "database-test-tf"   // nama id dari database
#   db_name                = "testdbTerraform"    // create db kosongan baru
#   username               = var.db_username
#   password               = var.db_password
#   port                   = 3306
#   storage_type           = "gp2"
#   allocated_storage      = 5
#   parameter_group_name   = "default.${aws_db_instance.rds-test-tf.engine}${aws_db_instance.rds-test-tf.engine_version}"
  
#   db_subnet_group_name   = aws_db_subnet_group.rds_def_subnetgroup.name
#   vpc_security_group_ids = [aws_security_group.rds-sg.id]
#   availability_zone      = data.aws_availability_zones.az_available.names[0]
#   publicly_accessible    = false
#   multi_az               = false
#   skip_final_snapshot    = true 
#   apply_immediately      = true

#   tags = {
#     "Name" = "rds-db-test"
#   }
# }

# output "rds_hostname" {
#   description = "RDS instance hostname"
#   value       = aws_db_instance.rds-test-tf.address
#   # sensitive   = true
# }