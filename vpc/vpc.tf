resource "aws_default_vpc" "default" {
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

data "aws_subnet" "subnet_a" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["${var.region}a"]
  }
}
