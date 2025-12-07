output "KKE_vpc_name" {
  value = aws_vpc.datacenter_priv_vpc.tags["Name"]
}

output "KKE_subnet_name" {
  value = aws_subnet.datacenter_priv_subnet.tags["Name"]
}

output "KKE_ec2_private" {
  value = aws_instance.datacenter_priv_ec2.tags["Name"]
}
