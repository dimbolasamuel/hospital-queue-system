resource "aws_wafv2_web_acl" "example_acl" {
  name        = "example-web-acl"
  scope       = "REGIONAL" # or "CLOUDFRONT"
  description = "Example Web ACL"

  rule {
    name     = "sql-injection-rule"
    priority = 1
    action   = {
      block {}
    }
    statement {
      byte_match_statement {
        search_string = "SELECT"
        field_to_match {
          query_string {}
        }
        text_transformations {
          type = "LOWERCASE"
        }
        positional_constraint = "CONTAINS"
      }
    }
    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name = "sqlInjectionMetric"
    }
  }

  default_action {
    allow {}
  }

  visibility_config {
    sampled_requests_enabled = true
    cloudwatch_metrics_enabled = true
    metric_name = "webAclMetric"
  }
}

