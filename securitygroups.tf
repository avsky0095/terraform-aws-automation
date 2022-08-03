
# PUBLIC SUBNET SECURITY GROUP
# ---------------------------------------------------------------

resource "aws_security_group" "publicsub-sg" {
  name                = "publicsub-sg"
  description         = "Allow HTTP+SSH inbound traffic"
  vpc_id              = aws_vpc.Main.id

  ingress {
    description       = "HTTP from VPC"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
    # self             = true                 // menerapkan aturan ingress = egress
  }

  ingress {
    description       = "HTTPS from VPC"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Allow SSH from MyIP"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = [ "${aws_network_interface.net-interface.private_ip}/32" ]
    # cidr_blocks       = ["0.0.0.0/0"]
  }

  # Allow all Outbound 
  egress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Public Subnet Secgroup - Allow HTTP and SSH"
  }
}


# PRIVATE SUBNET SECURITY GROUP
# ---------------------------------------------------------------

resource "aws_security_group" "privatesub-sg" {
  name                = "privatesub-sg"
  description         = "Allow inbound from public subnet"
  vpc_id              = aws_vpc.Main.id

  ingress {
    description       = "ALL"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_groups   = [ aws_security_group.NATBas-sg.id, aws_security_group.publicsub-sg.id ]
    # ipv6_cidr_blocks  = ["::/0"]
  }

  # Allow all Outbound 
  egress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    # security_groups   = [ aws_security_group.NATBas-sg.id ]
    # ipv6_cidr_blocks  = ["::/0"]
  }

  tags = {
    "Name" = "Private Subnet - allow from pubsub"
  }
}


# NETWORK ADDRESS TRANSLATION (NAT) INSTANCE / BASTION HOST SECURITY GROUP
# ---------------------------------------------------------------

resource "aws_security_group" "NATBas-sg" {
  name                = "NAT Instance/Bastion Host security group"
  description         = "security group for NAT-gw/NAT-instance/Bastion host"
  vpc_id              = aws_vpc.Main.id

  ingress {
    description       = "inbound HTTP"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    description       = "inbound HTTPs"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    description       = "open port for ssh tunnelling to private subnet database (optional)"
    from_port         = 3300
    to_port           = 3300
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    description       = "inbound SSH from myIP"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = [var.myIP]
  }     

  egress {
    description       = "outbound to ALL traffic"
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    "Name"            = "NAT/Bastion Host security group"
  }
}

# RELATIONAL DATABASE SERVICE (RDS) SECURITY GROUP
# ---------------------------------------------------------------

resource "aws_security_group" "rds-sg" {
  name                = "RDS security group"
  description         = "security group for RDS Instances"
  vpc_id              = aws_vpc.Main.id

  ingress {
    description       = "inbound to RDS DB"
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    # cidr_blocks       = [aws_subnet.publicsubnets_primary.cidr_block, aws_subnet.publicsubnets_secondary.cidr_block]
    # security_groups   = [ aws_security_group.ALL-sg.id ]
    cidr_blocks       = ["0.0.0.0/0"]
  }     

  egress {
    description       = "outbound to ALL traffic"
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    "Name"            = "RDS security group"
  }
}


# LOAD BALANCER SECURITY GROUP
# ---------------------------------------------------------------

resource "aws_security_group" "lb-sg" {
  name                = "Load balancer sec group"
  description         = "security group for Load Balancer"
  vpc_id              = aws_vpc.Main.id

  ingress {
    description       = "inbound HTTP"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    description       = "inbound HTTPs"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    description       = "outbound to all traffic"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    "Name"            = "Load Balancer secgroup"
  }
}


# ALL TRAFFIC SECURITY GROUP (FOR TESTING ONLY)
# ---------------------------------------------------------------

resource "aws_security_group" "ALL-sg" {
  name                = "All traffic sec group"
  description         = "security group for ALL traffic"
  vpc_id              = aws_vpc.Main.id

  ingress {
    description       = "inbound from ALL traffic"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    description       = "outbound from ALL traffic"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                = "ALL Traffic secgroup"
    "Source-Destination"  = "All Traffic"
  }
}


