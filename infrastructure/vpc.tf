  
  # Define the main VPC with a large CIDR block
  resource "aws_vpc" "main" {
    cidr_block           = "192.168.0.0/16"  # Large CIDR block for the entire VPC
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
      Name = "django-vpc"
    }
  }

  # ------------------------------------------------------------------------------
  # Public Subnets (2 Availability Zones)
  # These are for resources that need internet access (e.g., EC2, ALB)
  # ------------------------------------------------------------------------------
  # Public subnets in two AZs

  resource "aws_subnet" "public_1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "192.168.72.0/24"
    availability_zone       = "ap-southeast-1a"
    map_public_ip_on_launch = true # Automatically assign public IPs to EC2s

    tags = {
      Name = "public-subnet-1"
    }
  }

  resource "aws_subnet" "public_2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "192.168.73.0/24"
    availability_zone       = "ap-southeast-1b"
    map_public_ip_on_launch = true

    tags = {
      Name = "public-subnet-2"
    }
  }



  # ------------------------------------------------------------------------------
  # Private Subnets (2 Availability Zones)
  # These are isolated from the internet (e.g., backend services, databases)
  # ------------------------------------------------------------------------------
  # Private subnets in two AZs
  resource "aws_subnet" "private_1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "192.168.101.0/24"
    availability_zone = "ap-southeast-1a"

    tags = {
      Name = "private-subnet-1"
    }
  }

  resource "aws_subnet" "private_2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "192.168.102.0/24"
    availability_zone = "ap-southeast-1b"

    tags = {
      Name = "private-subnet-2"
    }
  }


  # ------------------------------------------------------------------------------
  # Internet Gateway: For public internet access
  # ------------------------------------------------------------------------------
  # Internet Gateway for public subnets
  resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "django-igw"
    }
  }


  # Public Route Table
  resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "public-rt"
    }
  }

  # Route to Internet Gateway for outbound internet traffic
  resource "aws_route" "public_internet_access" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
  }

  # Associate Public Subnet 1 with Public Route Table
  resource "aws_route_table_association" "public_1" {
    subnet_id      = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
  }

  # Associate Public Subnet 2 with Public Route Table (optional but recommended)
  resource "aws_route_table_association" "public_2" {
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
  }
