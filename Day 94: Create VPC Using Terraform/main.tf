resource "aws_vpc" "nautilus-vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "nautilus-vpc"
  }
}
