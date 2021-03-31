output "vpc-id" {
  
     value = [aws_vpc.tw-vpc.vpc_id]

}

output "private-subnet-ids" {


      value = toset([
    for subnet in aws_subnet.private-subnet-app   : subnet.id
  ])
}