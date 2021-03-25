resource "aws_budgets_budget" "my-budget" {
  name              =  var.budget_name
  budget_type       =  var.budget_type
  limit_amount      =  var.limit_amount
  limit_unit        =  "USD"
  time_period_start =  "2021-03-24_00:00"
  time_unit         =  var.time_unit


  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  =  10
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses =  var.email_addresses
  }
}
