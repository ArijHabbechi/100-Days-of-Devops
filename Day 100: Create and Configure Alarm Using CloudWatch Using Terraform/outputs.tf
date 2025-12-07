output "KKE_instance_name" {
  description = "Name tag of the EC2 instance"
  value       = aws_instance.nautilus_ec2.tags["Name"]
}

output "KKE_alarm_name" {
  description = "Name of the CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.nautilus_alarm.alarm_name
}
