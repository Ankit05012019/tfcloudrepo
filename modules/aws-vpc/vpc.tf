resource "aws_vpc" "th-vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {

    Name        = var.name
    environment = var.environment
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id     = aws_vpc.th-vpc.id
  depends_on = ["aws_vpc.th-vpc"]

  tags = {
    Name        = var.name
    environment = var.environment
  }
}

/*
  Public Subnet
*/

/*resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = lookup(var.public_subnets, element(keys(var.public_subnets), count.index))
  availability_zone       = element(keys(var.public_subnets), count.index)
  map_public_ip_on_launch = true*/

resource "aws_subnet" "public-subnet" {

   for_each = var.public_subnets
   vpc_id   = aws_vpc.th-vpc.id
   cidr_block = each.value
   availability_zone = each.key

   map_public_ip_on_launch = true



  tags = {
    Name        = "${each.key}-public"
    environment = var.environment
  }

  depends_on = ["aws_vpc.th-vpc"]
}

resource "aws_route_table" "public-route-table" {
  vpc_id           = aws_vpc.th-vpc.id
  #propagating_vgws = [var.public_propagating_vgws]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name        = "${var.name} (public)"
    environment = "${var.environment}"
  }

  depends_on = ["aws_vpc.th-vpc", "aws_internet_gateway.default"]
}

resource "aws_route_table_association" "public" {

  for_each       =  var.public_subnets
  subnet_id      =  aws_subnet.public-subnet[each.key].id
  #subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = aws_route_table.public-route-table.id
  #count          = "${length(keys(var.public_subnets))}"
}

/*
  Private Subnet
*/

resource "aws_subnet" "private-subnet" {
  #count = "${length(keys(var.private_subnets))}"

  #vpc_id            = "${aws_vpc.default.id}"
  #cidr_block        = "${lookup(var.private_subnets, element(keys(var.private_subnets), count.index))}"
  #availability_zone = "${element(keys(var.private_subnets), count.index)}"
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.th-vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  map_public_ip_on_launch = true


  tags = {
    Name            = "${each.key}-public"
    environment     = "${var.environment}"
  }

  depends_on = ["aws_vpc.th-vpc"]
}

resource "aws_route_table" "private-route-table" {
 
  for_each         = var.private_subnets
  vpc_id           = aws_vpc.th-vpc.id
  #propagating_vgws = ["${var.private_propagating_vgws}"]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id =  aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name            = "${each.key}-public"
    environment     = "${var.environment}"
  }

  depends_on = ["aws_vpc.th-vpc", "aws_nat_gateway.nat"]
}

resource "aws_route_table_association" "private" {

  for_each       =  var.private_subnets
  subnet_id      =  aws_subnet.private-subnet[each.key].id
  
  route_table_id = aws_route_table.private-route-table[each-key].id
  #count = "${length(var.private_subnets)}"

  #subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  depends_on = ["aws_subnet.private-subnet", "aws_route_table.private-route-table"]
}

/*
  NAT Gateway
*/

resource "aws_eip" "aws-eip" {
  
  for_each       =  var.public_subnets
  vpc            =  true
}

resource "aws_nat_gateway" "nat" {
  #count         = "${length(var.public_subnets)}"
  for_each      =  var.public_subnets 
  allocation_id =  aws_eip.aws-eip[each.key].id
  subnet_id     =  aws_subnet.public-subnet[each.key].id
  depends_on    = ["aws_subnet.public-subnet"]
}
