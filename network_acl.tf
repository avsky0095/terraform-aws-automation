
# NETWORK ACL ASSOCIATION TO SUBNETS
# ---------------------------------------------------------------

resource "aws_network_acl_association" "nacl_assoc_mgmtsub" {
  network_acl_id  = aws_network_acl.managementNACL.id
  subnet_id       = aws_subnet.managementsubnet.id
}

resource "aws_network_acl_association" "nacl_assoc_pubsub" {
  count           = length(aws_subnet.publicsubnets)

  network_acl_id  = aws_network_acl.publicNACL.id
  subnet_id       = aws_subnet.publicsubnets[count.index].id
}

resource "aws_network_acl_association" "nacl_assoc_privsub" {
  count           = length(aws_subnet.privatesubnets)

  network_acl_id  = aws_network_acl.privateNACL.id
  subnet_id       = aws_subnet.privatesubnets[count.index].id
}


# MANAGEMENT SUBNET NETWORK ACL
# ---------------------------------------------------------------

resource "aws_network_acl" "managementNACL" {
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
    Name       = "Network ACLs - Management Subnet"
  }
}


# PUBLIC SUBNET NETWORK ACL
# ---------------------------------------------------------------

resource "aws_network_acl" "publicNACL" {
  vpc_id       = aws_vpc.Main.id

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
    from_port  = 22
    to_port    = 22
    # cidr_block = "${aws_instance.nat-bastion.private_ip}/32"
    cidr_block = aws_subnet.managementsubnet.cidr_block
  }
  
  # Another ports
  ingress {
    protocol   = "tcp"
    rule_no    = 140
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
    Name       = "Network ACLs - Public Subnets"
  }
}


# PRIVATE NETWORK ACL
# ---------------------------------------------------------------

resource "aws_network_acl" "privateNACL" {
  vpc_id       = aws_vpc.Main.id


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
    # cidr_block = "${aws_instance.nat-bastion.private_ip}/32"
    cidr_block = aws_subnet.managementsubnet.cidr_block
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
    Name       = "Network ACLs - Private Subnets"
  }  
}



# ALL TRAFFIC NETWORK ACL (testing purpose only)
# ---------------------------------------------------------------

resource "aws_network_acl" "all" {
  vpc_id       = aws_vpc.Main.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100          //110, 120, 130, dst
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  
}


# DRAFTS
# ---------------------------------------------------------------


# network association to public subnet
# resource "aws_network_acl_association" "nacl_assoc_pubsub" {
#   network_acl_id  = aws_network_acl.publicNACL.id
#   subnet_id       = aws_subnet.publicsubnets_primary.id
# }

# # network association to private subnet
# resource "aws_network_acl_association" "nacl_assoc_privsub" {
#   network_acl_id  = aws_network_acl.privateNACL.id
#   subnet_id       = aws_subnet.privatesubnets_primary.id
# }

# # NACL SECOND AZ
# # ----------------

# # network association to public subnet secondary
# resource "aws_network_acl_association" "nacl_assoc_pubsub_sec" {
#   network_acl_id  = aws_network_acl.publicNACL.id
#   subnet_id       = aws_subnet.publicsubnets_secondary.id
# }

# # network association to private subnet secondary
# resource "aws_network_acl_association" "nacl_assoc_privsub_sec" {
#   network_acl_id  = aws_network_acl.privateNACL.id
#   subnet_id       = aws_subnet.privatesubnets_secondary.id
# }
