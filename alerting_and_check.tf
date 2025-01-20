resource "aws_route53_health_check" "dns" {
  fqdn              = "chandigarhtourism.site"
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}


resource "aws_sns_topic" "alert" {
  name = "dns-health-check-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alert.arn
  protocol  = "email"
  endpoint  = "akshaydhadwal2@gmail.com"
}


resource "aws_cloudwatch_metric_alarm" "cw_alarm" {
  alarm_name          = "DNSHealthCheckAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1

  alarm_actions = [aws_sns_topic.alert.arn]
}
