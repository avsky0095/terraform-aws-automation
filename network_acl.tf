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

  # SSH
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.myIP
    from_port  = 22
    to_port    = 22
  }

  # HTTP
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "test - Network ACLs"
  }
}
