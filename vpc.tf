
# CREATE VPC
# ---------------------------------------------------------------

#  Create the VPC
resource "aws_vpc" "Main" {                 # Creating VPC here
  cidr_block       = var.main_vpc_cidr      # Defining the CIDR block use 10.0.0.0/24 for demo
  instance_tenancy = "default"

  tags = {
    Name = "test VPC"
  }
}


# CREATE GATEWAYS IGW/NAT-GW
# ---------------------------------------------------------------

#  Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" {     # Creating Internet Gateway
  vpc_id = aws_vpc.Main.id                  # vpc_id will be generated after we create VPC

  tags = {
    Name = "test - Internet Gateway (igw)"
  }
}


# Creating Elastic IP for NAT Gateway
resource "aws_eip" "nateIP" {
  vpc = true

  tags = {
    "Name" = "test - Elastic IP for natgw"
  }
}

#  Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.publicsubnets.id

  tags = {
    Name = "test - NAT Gateway (nat-gw)"
  }
}


# CREATE SUBNETS
# ---------------------------------------------------------------

#  Create a Public Subnets.
resource "aws_subnet" "publicsubnets" {     # Creating Public Subnets
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.public_subnets           # CIDR block of public subnets
  availability_zone = var.availability_zone

  tags = {
    Name = "test - Public Subnet"
  }
}

#  Create a Private Subnet                  # Creating Private Subnets
resource "aws_subnet" "privatesubnets" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.private_subnets          # CIDR block of private subnets
  availability_zone = var.availability_zone

  tags = {
    Name = "test - Private Subnet"
  }
}


# CREATE ROUTE TABLES
# ---------------------------------------------------------------

#  Route table for Public Subnet's
resource "aws_route_table" "PublicRT" {     # Creating RT for Public Subnet
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"                # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Route Table pubsub -> igw -> inet"
  }
}

#  Route table for Private Subnet's
resource "aws_route_table" "PrivateRT" {    # Creating RT for Private Subnet
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0"            # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Name = "Route Table privsub -> natgw -> inet"
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

// public subnet -> route table -> igw -> internet
// private subnet -> route table -> nat-gw -> internet
