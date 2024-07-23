
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }

}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 0)

  tags = {
    Name = var.public_subnet_name
  }


}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 1)

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public_rt_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.public_internet_destination_cidr
  gateway_id             = aws_internet_gateway.this.id
}



resource "aws_nat_gateway" "this" {
  allocation_id = data.aws_eip.this.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.natgateway_name
  }

  depends_on = [aws_internet_gateway.this]

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route" "private_rt_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.public_internet_destination_cidr
  nat_gateway_id         = aws_nat_gateway.this.id
}

# # resource "aws_route_table_association" "nat_association" {
# #   subnet_id      = aws_subnet.public_subnet.id
# #   route_table_id = aws_route_table.this.id
# #   gateway_id     = aws_nat_gateway.this.id
# # }



# resource "aws_inst" "name" {

# }