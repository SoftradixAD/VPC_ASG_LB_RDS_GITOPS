# Load Balancer
resource "aws_lb" "prod_lb" {
  name               = "prod-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [ aws_subnet.public.id, aws_subnet.public2.id ]

  enable_deletion_protection = false
}

# Route53 Frontend Record
resource "aws_route53_record" "prod_dns" {
  zone_id = var.zone_id
  name    = "chandigarhtourism.site"  
  type    = "A"
  alias {
    name                   = aws_lb.prod_lb.dns_name
    zone_id                = aws_lb.prod_lb.zone_id
    evaluate_target_health = true
  }
}