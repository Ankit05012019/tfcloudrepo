output "vpc-id" {
  
     value = aws_vpc.th-vpc.id

}

output "private-subnet-ids" {


      value = toset([
    for subnet in aws_subnet.private-subnet-app   : subnet.id
  ])
}