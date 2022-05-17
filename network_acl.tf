
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.Main.id
  

# OUTBOUND
# ---------------------------------------------------------------

  # outbound anywhere
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


# INBOUND
# ---------------------------------------------------------------

  # HTTP
  ingress {
    protocol   = "tcp"
    rule_no    = 100          //110, 120, 130, dst
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # HTTPS
  ingress {
    protocol   = "tcp"
    rule_no    = 110          //110, 120, 130, dst
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # SSH
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = var.myIP
    from_port  = 22
    to_port    = 22
  }

  tags = {
    Name = "test - Network ACLs"
  }
}

# network association to public subnet
resource "aws_network_acl_association" "nacl_assoc_pubsub" {
  network_acl_id = aws_network_acl.main.id
  subnet_id = aws_subnet.publicsubnets.id
}

# network association to private subnet
# resource "aws_network_acl_association" "nacl_assoc_privsub" {
#   network_acl_id = aws_network_acl.main.id
#   subnet_id = aws_subnet.privatesubnets.id
# }

// second acl