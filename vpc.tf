resource "aws_vpc" "terra" {
  cidr_block = "10.233.0.0/16"
  tags       = var.common_tags
}

resource "aws_subnet" "pub" {
  count                   = length(data.aws_availability_zones.online_azs.names)
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = "10.233.${0 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.online_azs.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "Public subnet ${1 + count.index}"
    author      = var.common_tags.author
    environment = var.common_tags.environment
    project     = var.common_tags.project
  }

}

resource "aws_subnet" "priv" {
  count                   = length(data.aws_availability_zones.online_azs.names)
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = "10.233.${50 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.online_azs.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name        = "Private subnet ${1 + count.index}"
    author      = var.common_tags.author
    environment = var.common_tags.environment
    project     = var.common_tags.project
  }


}

resource "aws_internet_gateway" "kristo" {
  vpc_id = aws_vpc.terra.id
  tags   = var.common_tags
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.terra.id
  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.kristo.id
  }
  tags = var.common_tags
}

resource "aws_route_table_association" "kristo" {
  count          = length(data.aws_availability_zones.online_azs.names)
  route_table_id = aws_route_table.igw.id
  subnet_id      = aws_subnet.pub[count.index].id
}