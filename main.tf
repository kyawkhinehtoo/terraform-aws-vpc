
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
resource "tls_private_key" "this" {
  algorithm = var.private_key_algorithm
  rsa_bits  = var.private_key_ras_bit
}
resource "aws_key_pair" "this" {
  key_name   = var.aws_key_pair_key_name
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_vpc.this.id

}

resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.this.id
  from_port         = 22 #port range ဖြစ်တဲ့အတွက် from နှင့် to ထားခြင်းဖြစ်
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "this" {
  count                       = 1
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name
  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}

output "private_key_pem" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}
