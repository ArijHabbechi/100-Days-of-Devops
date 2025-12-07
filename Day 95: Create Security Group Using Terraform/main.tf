data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "xfusion_sg" {
  name        = "xfusion-sg"
  description = "Security group for Nautilus App Servers"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "xfusion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "xfusion_sg_http" {
  security_group_id = aws_security_group.xfusion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "xfusion_sg_ssh" {
  security_group_id = aws_security_group.xfusion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
