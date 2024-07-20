resource "aws_sns_topic" "example" {
  name = "CPU_USAGE"
}

resource "aws_sns_topic_subscription" "example" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = var.sns_email
}
