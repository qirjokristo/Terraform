data "aws_availability_zones" "online" {
  state = "available"
}

resource "aws_vpc" "panamax" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.common_tags, { Name = var.project })
}

resource "aws_subnet" "pub" {
  count                   = length(data.aws_availability_zones.online.names)
  vpc_id                  = aws_vpc.panamax.id
  cidr_block              = cidrsubnet(aws_vpc.panamax.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.online.names[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(var.common_tags, { Name = "${var.project} Public subnet ${1 + count.index}" })
}

resource "aws_subnet" "priv" {
  count                   = length(data.aws_availability_zones.online.names)
  vpc_id                  = aws_vpc.panamax.id
  cidr_block              = cidrsubnet(aws_vpc.panamax.cidr_block, 8, count.index + 100)
  availability_zone       = data.aws_availability_zones.online.names[count.index]
  map_public_ip_on_launch = false
  tags                    = merge(var.common_tags, { Name = "${var.project} Private subnet ${1 + count.index}" })


}

resource "aws_internet_gateway" "panamax" {
  vpc_id = aws_vpc.panamax.id
  tags   = merge(var.common_tags, { Name = var.project })
}

resource "aws_route_table" "panamax" {
  vpc_id = aws_vpc.panamax.id
  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.panamax.id
  }
  tags = merge(var.common_tags, { Name = var.project })
}

resource "aws_route_table_association" "panamax" {
  count          = length(aws_subnet.pub)
  route_table_id = aws_route_table.panamax.id
  subnet_id      = aws_subnet.pub[count.index].id
}