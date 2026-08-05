output "vpc_id" {
  value = aws_vpc.network.id
}

output "private_subnets" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "vpc_cider" {
  value = aws_vpc,network.cidr_block
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}

output "web_security_group_id" {
  value = aws_security_group.web.id
}
