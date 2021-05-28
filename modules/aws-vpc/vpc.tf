locals {
  eks_public_subnet_tags  = var.cluster_name != "" ? { "kubernetes.io/cluster/${var.cluster_name}" : "shared", "kubernetes.io/role/elb" : "1" } : {}
  eks_private_subnet_tags = var.cluster_name != "" ? { "kubernetes.io/cluster/${var.cluster_name}" : "shared", "kubernetes.io/role/internal-elb" : "1" } : {}
}


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

resource "aws_subnet" "public-subnet" {

   for_each = var.public_subnets
   vpc_id   = aws_vpc.th-vpc.id
   cidr_block = each.value
   availability_zone = each.key

   map_public_ip_on_launch = true


   tags = merge(
   
    local.eks_public_subnet_tags,
    {
    Name        = "${var.name}-${each.key}-public"
    environment = var.environment
  })
  

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
    Name        = "${var.name}-public"
    environment = "${var.environment}"
  }

  depends_on = ["aws_vpc.th-vpc", "aws_internet_gateway.default"]
}

resource "aws_route_table_association" "public" {

  for_each       =  var.public_subnets
  subnet_id      =  aws_subnet.public-subnet[each.key].id
  route_table_id = aws_route_table.public-route-table.id
  
}


/*Private Subnet App*/


resource "aws_subnet" "private-subnet-app" {

  for_each          = var.private_subnets_app
  vpc_id            = aws_vpc.th-vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  map_public_ip_on_launch = true


  tags = merge(
     local.eks_private_subnet_tags,
    {
    Name        = "${var.name}-${each.key}-private-app"
    environment = "${var.environment}"
  })

  depends_on = ["aws_vpc.th-vpc"]
}

resource "aws_route_table" "private-route-table-app" {
 
  for_each         = var.private_subnets_app
  vpc_id           = aws_vpc.th-vpc.id
  #propagating_vgws = ["${var.private_propagating_vgws}"]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id =  aws_nat_gateway.nat.id
  }

  tags = {
    Name            = "${each.key}-private-app"
    environment     = "${var.environment}"
  }

  depends_on = ["aws_vpc.th-vpc", "aws_nat_gateway.nat"]
}

resource "aws_route_table_association" "private-app" {

  for_each       =  var.private_subnets_app
  subnet_id      =  aws_subnet.private-subnet-app[each.key].id
  
  route_table_id = aws_route_table.private-route-table-app[each.key].id

  depends_on = ["aws_subnet.private-subnet-app", "aws_route_table.private-route-table-app"]
}


/* Private Subnet DB */

/*
resource "aws_subnet" "private-subnet-db" {

  for_each          = var.private_subnets_db
  vpc_id            = aws_vpc.th-vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  map_public_ip_on_launch = true


  tags = {
    Name            = "${each.key}-private-db"
    environment     = "${var.environment}"
  }

  depends_on = ["aws_vpc.th-vpc"]
}

resource "aws_route_table" "private-route-table-db" {
 
  for_each         = var.private_subnets_db
  vpc_id           = aws_vpc.th-vpc.id
  #propagating_vgws = ["${var.private_propagating_vgws}"]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id =  aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name            = "${each.key}-private-db"
    environment     = "${var.environment}"
  }

  depends_on = ["aws_vpc.th-vpc", "aws_nat_gateway.nat"]
}

resource "aws_route_table_association" "private-db" {

  for_each       =  var.private_subnets_db
  subnet_id      =  aws_subnet.private-subnet-db[each.key].id
  
  route_table_id = aws_route_table.private-route-table-db[each.key].id

  depends_on = ["aws_subnet.private-subnet-db", "aws_route_table.private-route-table-db"]
}*/




  /*NAT Gateway*/


resource "aws_eip" "aws-eip" {
  
  #for_each       =  var.public_subnets
  vpc            =  true
}

resource "aws_nat_gateway" "nat" {
  #for_each      = var.public_subnets
  #allocation_id = aws_eip.aws-eip[each.key].id
  allocation_id  = aws_eip.aws-eip.id 
  #subnet_id     = aws_subnet.public-subnet[each.key].id
  subnet_id      = element(tolist([for subnet in aws_subnet.public-subnet : subnet.id]),0) 
  depends_on     = ["aws_subnet.public-subnet"]
}

