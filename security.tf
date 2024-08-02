resource "aws_wafv2_web_acl" "example_acl" {
  name        = "example-web-acl"
  scope       = "REGIONAL"
  description = "Example Web ACL"

  rule {
    name     = "block-post-requests-content-type-application-json"
    priority = 1

    action {
      block {}
    }

    statement {
      and_statement {
        statements = [
          {
            byte_match_statement {
              field_to_match {
                method {}
              }
              positional_constraint = "CONTAINS"
              search_string = "POST"
              text_transformation {
                priority = 0
                type = "NONE"
              }
            }
          },
          {
            not_statement {
              statement {
                byte_match_statement {
                  search_string = "application/json"
                  field_to_match {
                    single_header {
                      name = "content-type"
                    }
                  }
                  positional_constraint = "CONTAINS"
                  text_transformation {
                    priority = 0
                    type = "NONE"
                  }
                }
              }
            }
          }
        ]
      }
    }

    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name = "webAclMetric"
    }
  }
}
