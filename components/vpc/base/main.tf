resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = module.vpc_name.name
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${module.vpc_name.name}-public"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${module.vpc_name.name}-public-${each.value.availability_zone}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc.id
  }

  tags = {
    Name = "${module.vpc_name.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${module.vpc_name.name}-private-${each.value.availability_zone}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${module.vpc_name.name}-private"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}


# Commented out because $$$$$$
#
# resource "aws_eip" "private" {
#   for_each = aws_subnet.private
#
#   domain = "vpc"
# }
#
# resource "aws_nat_gateway" "private" {
#   for_each = aws_subnet.private
#
#   allocation_id = aws_eip.private[each.key].id
#   subnet_id     = each.value.id
# }
#
# resource "aws_route_table" "private" {
#   for_each = aws_nat_gateway.private
#
#   vpc_id = aws_vpc.vpc.id
#
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = each.value.id
#   }
# }
#
# resource "aws_route_table_association" "private" {
#   for_each = aws_subnet.private
#
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private[each.key].id
# }