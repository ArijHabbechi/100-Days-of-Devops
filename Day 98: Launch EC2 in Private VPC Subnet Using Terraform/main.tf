#Create VPC 
resource "aws_vpc" "datacenter_priv_vpc" {
  cidr_block = var.KKE_VPC_CIDR

  tags = {
    Name = "datacenter-priv-vpc"
  }
}

#Create subnet datacenter-priv-subnet
resource "aws_subnet" "datacenter_priv_subnet" {
  vpc_id            = aws_vpc.datacenter_priv_vpc.id
  cidr_block        = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false 

  tags = {
    Name = "datacenter-priv-subnet"
  }
}


#Security Group allowing access ONLY from VPC CIDR
resource "aws_security_group" "priv_sg" {
  name        = "datacenter-priv-sg"
  description = "Allow traffic only from within VPC"
  vpc_id      = aws_vpc.datacenter_priv_vpc.id

  # Allow all traffic *from inside VPC only*
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "datacenter-priv-sg"
  }
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    }
}

#EC2 Instance inside subnet
resource "aws_instance" "datacenter_priv_ec2" {
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.datacenter_priv_subnet.id
  vpc_security_group_ids      = [aws_security_group.priv_sg.id]
  ami = data.aws_ami.amazon_linux.id

  tags = {
    Name = "datacenter-priv-ec2"
  }
}
