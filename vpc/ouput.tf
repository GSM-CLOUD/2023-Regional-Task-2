output "vpc_id" {
  value = aws_default_vpc.default.id
}

output "public_subnet_a_id" {
  value = data.aws_subnet.subnet_a.id
}
