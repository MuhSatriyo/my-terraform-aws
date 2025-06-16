# For Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# For get Availability Zone currently
data "aws_availability_zones" "available" {}

# Create Subnet on Default VPC
resource "aws_subnet" "default_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = cidrsubnet(data.aws_vpc.default.cidr_block, 8, 0) # Subnet CIDR valid
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Default Subnet"
  }
}

# Crate Route Table
resource "aws_route_table" "default_route_table" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    "Name" = "Default Route Table"
  }
}

# Associate Subnet to Route Table
resource "aws_route_table_association" "default_subnet_association" {
  subnet_id      = aws_subnet.default_subnet.id
  route_table_id = aws_route_table.default_route_table.id
}

# Create Internet Gateway
resource "aws_internet_gateway" "default_igw" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    "Name" = "Default Internet Gateway"
  }
}

# Add Route to Route Table
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.default_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default_igw.id
}