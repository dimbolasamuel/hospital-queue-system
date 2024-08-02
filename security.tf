# Create WAF
resource "aws_waf" "hospital_queue_waf" {
  name        = "hospital-queue-waf"
  metric_name = "hospitalQueueWAF"
}

# Create WAF Rule to block SQL Injection
resource "aws_waf_rule" "sql_injection_rule" {
  name        = "sql-injection-rule"
  metric_name = "sqlInjectionRule"

   predicates {
    data_id = "aebd8870-d71d-4ced-8c39-695c7a3f83d0"
    negated = false
    type    = "ByteMatch"
  }
}

# Create WAF SQL Injection Match Set
resource "aws_waf_sql_injection_match_set" "sql_injection_match_set" {
  name = "sql-injection-match-set"

  sql_injection_match_tuple {
    field_to_match {
      type = "URI"
    }
    text_transformation {
      priority = 0
      type     = "NONE"
    }
  }
}

# Create WAF Web ACL
resource "aws_waf_web_acl" "hospital_queue_web_acl" {
  name        = "hospital-queue-web-acl"
  metric_name = "hospitalQueueWebACL"

  default_action {
    type = "ALLOW"
  }

  rule {
    priority = 1
    rule_id  = (link unavailable)
    type     = "REGULAR"
  }
}

# Associate WAF Web ACL with ALB
resource "aws_alb" "hospital_queue_alb" {
  name            = "hospital-queue-alb"
  subnets         = ["subnet-12345678", "subnet-90123456"]
  security_groups = ["sg-12345678"]
}

resource "aws_alb_listener" "hospital_queue_listener" {
  load_balancer_arn = aws_alb.hospital_queue_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.hospital_queue_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "hospital_queue_listener_rule" {
  listener_arn = aws_alb_listener.hospital_queue_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.hospital_queue_target_group.arn
  }

  condition {
    field  = "host-header"
    values = ["(link unavailable)"]
  }
}

resource "aws_alb_target_group" "hospital_queue_target_group" {
  name     = "hospital-queue-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"
}

# Associate WAF Web ACL with ALB Listener
resource "aws_alb_listener_rule" "hospital_queue_waf_rule" {
  listener_arn = aws_alb_listener.hospital_queue_listener.arn
  priority     = 2

  action {
    type = "waf"
    waf  {
      id   = (link unavailable)
      type = "AWS"
    }
  }
}
