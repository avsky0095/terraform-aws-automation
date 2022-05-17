resource "aws_security_group" "test-ec2-sg" {
  name        = "test-sg"
  description = "Allow HTTP+SSH inbound traffic"
  #   vpc_id      = [aws_vpc.vpc.id]

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
