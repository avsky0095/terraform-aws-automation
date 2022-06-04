
# NETWORK ACL ASSOCIATION TO SUBNETS
# ---------------------------------------------------------------

# network association to public subnet
resource "aws_network_acl_association" "nacl_assoc_pubsub" {
  network_acl_id  = aws_network_acl.publicNACL.id
  subnet_id       = aws_subnet.publicsubnets.id
}

# network association to private subnet
resource "aws_network_acl_association" "nacl_assoc_privsub" {
  network_acl_id  = aws_network_acl.privateNACL.id
  subnet_id       = aws_subnet.privatesubnets.id
}

# NACL SECOND AZ
# ----------------

# network association to public subnet secondary
resource "aws_network_acl_association" "nacl_assoc_pubsub_sec" {
  network_acl_id  = aws_network_acl.publicNACL.id
  subnet_id       = aws_subnet.publicsubnets_sec.id
}

# network association to private subnet secondary
resource "aws_network_acl_association" "nacl_assoc_privsub_sec" {
  network_acl_id  = aws_network_acl.privateNACL.id
  subnet_id       = aws_subnet.privatesubnets_sec.id
}


# PUBLIC NETWORK ACL
# ---------------------------------------------------------------

resource "aws_network_acl" "publicNACL" {
  vpc_id = aws_vpc.Main.id

# INBOUND
# ----------------

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

  # Another ports
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }


# OUTBOUND
# ----------------

  egress {
    protocol   = "-1"
    rule_no    = 100          //110, 120, 130, dst
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "test - Network ACLs"
  }
}


# PRIVATE NETWORK ACL
# ---------------------------------------------------------------

resource "aws_network_acl" "privateNACL" {
  vpc_id = aws_vpc.Main.id


# INBOUND
# ----------------

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
    cidr_block = "0.0.0.0/0"
    # cidr_block = "${data.aws_instances.NAT-instance.public_ips[0]}/32"
    from_port  = 22
    to_port    = 22
  }

  # Another ports
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

# OUTBOUND
# ----------------

  egress {
    protocol   = "-1"
    rule_no    = 100          //110, 120, 130, dst
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "test_sec - Network ACLs"
  }  
}



# DRAFTS
# ---------------------------------------------------------------

  # egress {
  #   protocol   = "tcp"
  #   rule_no    = 100
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 80
  #   to_port    = 80
  # }

  # egress {
  #   protocol   = "tcp"
  #   rule_no    = 110
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 443
  #   to_port    = 443
  # }

  # egress {
  #   protocol   = "tcp"
  #   rule_no    = 120
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 1024
  #   to_port    = 65535
  # }