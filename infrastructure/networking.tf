# https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331
# https://serverfault.com/questions/556363/what-is-the-difference-between-a-public-and-private-subnet-in-a-amazon-vpc

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  # These 2 attributes set to `true` cause an EC2 instance with a public IP address to also receive a DNS hostname (e.g. ec2-public-ipv4-address.region.compute.amazonaws.com).
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "webhooks_receiver_vpc"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_internet_gateway.id
  }

  tags = {
    Name = "webhooks_receiver_public_route_table"
  }
}


resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "webhooks_receiver_public_subnet"
  }
}

resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "webhooks_receiver_internet_gateway"
  }
}
