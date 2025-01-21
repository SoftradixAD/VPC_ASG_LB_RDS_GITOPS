resource "aws_sns_topic" "dns_health_check" {
  name = "dns_health_check_alerts"
}

resource "aws_sns_topic_subscription" "dns_health_check_email" {
  topic_arn = aws_sns_topic.dns_health_check.arn
  protocol  = "email"
  endpoint  = var.mail
}

resource "aws_route53_health_check" "dns_health_check" {
  fqdn                = "chandigarhtourism.site"
  type                = "HTTPS"
  resource_path       = "/"
  failure_threshold   = 3
  request_interval    = 30
  measure_latency     = true
  port                = 443
  enable_sni          = false
  regions             = ["us-west-2", "us-east-1", "us-west-1"] 
}

resource "aws_cloudwatch_metric_alarm" "dns_health_check_alarm" {
  alarm_name          = "dns_health_check_failure"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1

  dimensions = {
    HealthCheckId = aws_route53_health_check.dns_health_check.id
  }

  alarm_actions = [
    aws_sns_topic.dns_health_check.arn
  ]
}
