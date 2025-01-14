data "aws_availability_zones" "online" {
  state = "available"
}

resource "aws_vpc" "planarian" {
  cidr_block = var.vpc_cidr
  tags       = merge(local.common_tags, { Name = "${var.project}-vpc" })
}

resource "aws_subnet" "pub" {
  count                   = length(data.aws_availability_zones.online.names)
  vpc_id                  = aws_vpc.planarian.id
  cidr_block              = cidrsubnet(aws_vpc.planarian.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.online.names[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "${var.project}_public_subnet_${1 + count.index}" })
}

resource "aws_subnet" "priv" {
  count                   = length(data.aws_availability_zones.online.names)
  vpc_id                  = aws_vpc.planarian.id
  cidr_block              = cidrsubnet(aws_vpc.planarian.cidr_block, 8, count.index + 100)
  availability_zone       = data.aws_availability_zones.online.names[count.index]
  map_public_ip_on_launch = false
  tags                    = merge(local.common_tags, { Name = "${var.project}_private_subnet_${1 + count.index}" })


}

resource "aws_internet_gateway" "planarian" {
  vpc_id = aws_vpc.planarian.id
  tags   = merge(local.common_tags, { Name = "${var.project}-igw" })
}

resource "aws_route_table" "planarian" {
  vpc_id = aws_vpc.planarian.id
  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.planarian.id
  }
  tags = merge(local.common_tags, { Name = "${var.project}-rtb" })
}

resource "aws_route_table_association" "planarian" {
  count          = length(aws_subnet.pub)
  route_table_id = aws_route_table.planarian.id
  subnet_id      = aws_subnet.pub[count.index].id
}