# set up Cloudwatch group and log stream and retain logs for 14 days
resource "aws_cloudwatch_log_group"  "churn_log_group" {
    name    = "/churn_cluster/churn_service"
    retention_in_days = 14

    tags = {
        Name = "churn-app-cw-log-group"
    }
    
}

resource "aws_cloudwatch_log_stream" "churn_log_stream" {
    name   = "churn-app-log-stream"
    log_group_name = aws_cloudwatch_log_group.churn_log_group.name
}