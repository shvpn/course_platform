# Create a CloudWatch Log Group
resource "aws_cloudwatch_log_group" "example" {
  name              = "g2-cyber-course_platform"
  retention_in_days = 14
}

# Create an SNS Topic
resource "aws_sns_topic" "alert_topic" {
  name = "cpu_alerts_topic"
}

# Create an SNS Topic Subscription for email
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = "bunleapthay@gmail.com" 
}

# Create a CloudWatch Alarm for CPU Utilization in the Auto Scaling Group
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-alert"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors EC2 CPU utilization in the Auto Scaling Group"
  alarm_actions       = [aws_sns_topic.alert_topic.arn]

  dimensions = {
    AutoScalingGroupName = "${var.project_name}-asg" 
  }
}
