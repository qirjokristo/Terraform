data "aws_availability_zones" "online_azs" {
  state = "available"
}

resource "aws_vpc" "terra" {
  cidr_block = "10.233.0.0/16"
  tags       = merge(var.common_tags,{Name = "Kristo-project"})
}

resource "aws_subnet" "pub" {
  count                   = length(data.aws_availability_zones.online_azs.names)
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = cidrsubnet(aws_vpc.terra.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.online_azs.names[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(var.common_tags, { Name = "Public subnet ${1 + count.index}" })


}

resource "aws_subnet" "priv" {
  count                   = length(data.aws_availability_zones.online_azs.names)
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = "10.233.${50 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.online_azs.names[count.index]
  map_public_ip_on_launch = false
  tags                    = merge(var.common_tags, { Name = "Private subnet ${1 + count.index}" })


}

resource "aws_internet_gateway" "terra" {
  vpc_id = aws_vpc.terra.id
  tags       = merge(var.common_tags,{Name = "Kristo-project"})
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.terra.id
  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.terra.id
  }
 tags       = merge(var.common_tags,{Name = "Kristo-project"})
}

resource "aws_route_table_association" "terra" {
  count          = length(aws_subnet.pub)
  route_table_id = aws_route_table.igw.id
  subnet_id      = aws_subnet.pub[count.index].id
}