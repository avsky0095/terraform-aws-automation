
# CREATE VPC
# ---------------------------------------------------------------

#  Create the VPC
resource "aws_vpc" "Main" {            # Creating VPC here
  cidr_block       = var.main_vpc_cidr # Defining the CIDR block use 10.0.0.0/16 for demo
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "test VPC"
  }
}


# CREATE SUBNETS
# ---------------------------------------------------------------

#  Create a Public Subnets.
resource "aws_subnet" "publicsubnets" { # Creating Public Subnets
  vpc_id                  = aws_vpc.Main.id
  cidr_block              = var.public_subnets # CIDR block of public subnets
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true // auto-assign public ip address di instance

  tags = {
    Name = "test - Public Subnet"
  }
}

#  Create a Private Subnet
resource "aws_subnet" "privatesubnets" {
  vpc_id                  = aws_vpc.Main.id
  cidr_block              = var.private_subnets # CIDR block of private subnets
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "test - Private Subnet"
  }
}

# CREATE SUBNETS SECOND AVAILABILITY ZONE
# ------------------

#  Create a Public Subnets 2
resource "aws_subnet" "publicsubnets_sec" { # Creating Public Subnets
  vpc_id                  = aws_vpc.Main.id
  cidr_block              = var.public_subnets_sec # CIDR block of public subnets
  availability_zone       = var.availability_zone_sec
  map_public_ip_on_launch = true // auto-assign public ip address di instance

  tags = {
    Name = "test - Public Subnet-Sec"
  }
}

#  Create a Private Subnet 2
resource "aws_subnet" "privatesubnets_sec" {
  vpc_id                  = aws_vpc.Main.id
  cidr_block              = var.private_subnets_sec # CIDR block of private subnets
  availability_zone       = var.availability_zone_sec
  map_public_ip_on_launch = false

  tags = {
    Name = "test - Private Subnet-Sec"
  }
}


# CREATE GATEWAYS IGW/NAT-GW/NAT-interface
# ---------------------------------------------------------------

#  Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" { # Creating Internet Gateway
  vpc_id = aws_vpc.Main.id              # vpc_id will be generated after we create VPC

  tags = {
    Name = "test - Internet Gateway (igw)"
  }
}

# Creating Elastic IP for NAT Gateway/NAT Instance
resource "aws_eip" "nateIP" {
  instance = aws_instance.nat_instance.id
  vpc      = true

  tags = {
    # "Name" = "test - Elastic IP for natgw"
    "Name" = "test - Elastic IP for NAT-Instance"
  }
}

# nat interface for nat-instance
resource "aws_network_interface" "net-interface" {
  subnet_id         = aws_subnet.publicsubnets.id
  security_groups   = [aws_security_group.NAT-sg.id]
  source_dest_check = false

  tags = {
    "Name" = "NAT instance network interface"
  }
}

// disabled for future use
# #  Creating the NAT Gateway using subnet_id and allocation_id
# resource "aws_nat_gateway" "NATgw" {
#   allocation_id = aws_eip.nateIP.id
#   subnet_id     = aws_subnet.publicsubnets.id

#   tags = {
#     Name = "test - NAT Gateway (nat-gw)"
#   }
# }


# CREATE ROUTE TABLES
# ---------------------------------------------------------------

#  Route table for Public Subnet's
resource "aws_route_table" "PublicRT" { # Creating RT for Public Subnet
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Route Table pubsub -> igw -> inet"
  }
}

# #  Route table for Private Subnet's (ke nat instance)
resource "aws_route_table" "PrivateRT" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block           = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    network_interface_id = aws_network_interface.net-interface.id
    # nat_gateway_id = aws_nat_gateway.NATgw.id   // pakai ini bila mengaktifkan nat-gw
  }

  tags = {
    # Name = "Route Table privsub -> natgw -> inet"
    Name = "Route Table privsub -> nat-inst -> inet"
  }
}


# ROUTE TABLES ASSOCIATION TO
# ---------------------------------------------------------------

#  Route table Association with Public Subnet's
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.publicsubnets.id
  route_table_id = aws_route_table.PublicRT.id
}

#  Route table Association with Private Subnet's
resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.privatesubnets.id
  route_table_id = aws_route_table.PrivateRT.id
}

#  Route table Association with Public Subnet's Secondary
resource "aws_route_table_association" "PublicRTassociationSec" {
  subnet_id      = aws_subnet.publicsubnets_sec.id
  route_table_id = aws_route_table.PublicRT.id
}

#  Route table Association with Private Subnet's Secondary
resource "aws_route_table_association" "PrivateRTassociationSec" {
  subnet_id      = aws_subnet.privatesubnets_sec.id
  route_table_id = aws_route_table.PrivateRT.id
}

// public subnet -> route table -> igw -> internet
// private subnet -> route table -> nat-gw -> internet
