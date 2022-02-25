#Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
  cidr_block           = var.sec_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "CloudGen Firewall"
  }

}
#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_master.id
  tags = {
    Name = "CGF Internet GW"
  }
}

#Create firewall subnet 
resource "aws_subnet" "firewall" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = var.firewall_vpc_subnet
  tags = {
    Name = "firewall"
  }
}
resource "aws_subnet" "protected" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = var.protected_vpc_subnet
  tags = {
    Name = "protected"
  }
}
#Create route table for firewall subnet
resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.vpc_master.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Route Table"
  }
}

#Create route table for protected subnet
resource "aws_route_table" "protected_route" {
  vpc_id = aws_vpc.vpc_master.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.firewall-nic.id
  }
  tags = {
    Name = "Route Table "
  }
}

#Overwrite default route table of protected subnet
resource "aws_route_table_association" "set-protected-routes" {
  subnet_id      = aws_subnet.protected.id
  route_table_id = aws_route_table.protected_route.id
}

#Overwrite default route table of VPC(Master) with our route table entries
resource "aws_route_table_association" "set-firewall-routes" {
  subnet_id      = aws_subnet.firewall.id
  route_table_id = aws_route_table.internet_route.id
}
