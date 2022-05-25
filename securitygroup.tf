resource "aws_security_group" "publicsub-sg" {
  name        = "publicsub-sg"
  description = "Allow HTTP+SSH inbound traffic"
  vpc_id      = aws_vpc.Main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
    # self             = true
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
    # self             = true
  }

  ingress {
    description = "Allow SSH from MyIP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ var.myIP ]
    # cidr_blocks = [aws_vpc.Main.cidr_block]
    # ipv6_cidr_blocks = ["::/0"]
    # self             = true
  }


  # Allow all Outbound 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "Allow HTTP and SSH"
  }
}


resource "aws_security_group" "privatesub-sg" {
  name        = "privsub-sg"
  description = "Allow inbound from public subnet"
  vpc_id      = aws_vpc.Main.id

  ingress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # security_groups = ["${aws_security_group.publicsub-sg.id}"]
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
    # self             = true
  }

  # Allow all Outbound 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "allow from pubsub"
  }
}


# security group for NAT
resource "aws_security_group" "NAT-sg" {
  name          = "NAT security group"
  description   = "security group for NAT-gw/NAT-instance"
  vpc_id        = aws_vpc.Main.id

  ingress {
    description = "inbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # self             = true
  }

  ingress {
    description = "inbound HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # self             = true
  }

  ingress {
    description = "inbound SSH from myIP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myIP}"]
    # self             = true
  }

  egress {
    description = "outbound to ALL traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # self        = true
  }  

  tags = {
    "Name" = "NAT security group"
  }
}


// untuk testing
# security group ALL TRAFFIC
resource "aws_security_group" "ALL-sg" {
  description = "security group for ALL traffic"
  vpc_id = aws_vpc.Main.id

  ingress {
    description = "inbound from ALL traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # self             = true
  }

  egress {
    description = "outbound from ALL traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # self        = true
  }

  tags = {
    "Name"                = "Default security group"
    "Source/Destination"  = "All Traffic"
  }
}