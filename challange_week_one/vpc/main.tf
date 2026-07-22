# resource "aws_s3_object" "object" {
#   bucket  = var.s3_bucket_name
#   key     = var.s3_object_name
#   content = ""

# }

# provider "aws" {
#   region = "us-east-1"
# }

locals {
  owner             = "Ayomide Adenle"
  project           = "building a vpc and ec2 instance HUG terraform challenge"
  name              = var.aws_vpc
  availability_zone = "us-east-1a"
  region            = "us-east-1"

  #tags = 
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${local.name}"
  }
}

# this data source is used to get the availability zones in the region (e.g. us-east-1a, us-east-1b, us-east-1c)
data "aws_availability_zones" "available" {}



resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.name}-public-subnet${count.index + 1}"
    #"kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private" {

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index + 4}.0/24" #or  cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  count             = 3


  tags = {
    Name = "${local.name}-private-subnet-${count.index + 1}"
    ## "kubernetes.io/role/internal-elb" = "1"
  }
}

#internet gateway
resource "aws_internet_gateway" "adenle-Igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-internet-gateway"
  }
}

resource "aws_route_table" "ade-pub-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.adenle-Igw.id
  }

  tags = {
    Name = "${local.name}-public-route-table"
  }
}

resource "aws_route_table_association" "ade-pub-RT-assoc" {
  count          = 3 #length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.ade-pub-RT.id
}

#elastic ip

#private route table
resource "aws_route_table" "ade-priv-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ade-nat-gateway.id
  }

  tags = {
    Name = "${local.name}-public-route-table"
  }
}

#subnet route table for private subnets
resource "aws_route_table_association" "ade-private-RT-assoc" {
  count          = 3 #length(aws_subnet.public)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.ade-priv-RT.id
}
# This route table is used for private subnets to route traffic through the NAT gateway

resource "aws_eip" "ade-eip" {
  domain = "vpc"

  tags = {
    Name = "${local.name}-elastic-ip"
  }
}
#NAT Gateway
resource "aws_nat_gateway" "ade-nat-gateway" {
  allocation_id = aws_eip.ade-eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${local.name}-nat-gateway"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.ade-priv-RT.id]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "s3:*"
        Resource  = "*"
        Principal = "*"
      }
    ]
  })

  tags = {
    Environment = "${local.name}-s3-endpoint"
  }
}