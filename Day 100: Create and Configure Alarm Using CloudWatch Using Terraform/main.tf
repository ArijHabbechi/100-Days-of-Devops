resource "aws_sns_topic" "sns_topic" {
  name = "nautilus-sns-topic"
}


# --- EC2 instance ---
resource "aws_instance" "nautilus_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "nautilus-ec2"
  }
}

# --- CloudWatch CPU Utilization alarm ---
resource "aws_cloudwatch_metric_alarm" "nautilus_alarm" {
  alarm_name          = "nautilus-alarm"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300                        # 5 minutes
  evaluation_periods  = 1                          # 1 consecutive period
  threshold           = 90
  comparison_operator = "GreaterThanOrEqualToThreshold"

  alarm_actions = [
    data.aws_sns_topic.sns_topic.arn
  ]

  dimensions = {
    InstanceId = aws_instance.nautilus_ec2.id
  }

  treat_missing_data = "missing"
}
