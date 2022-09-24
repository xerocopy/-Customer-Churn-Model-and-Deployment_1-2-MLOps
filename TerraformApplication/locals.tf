locals {
  code_build_service_role = "arn:aws:iam::516003265142:role/service-role/codebuild-Customer-Churn_1-2-MLOps-service-role"
  code_commit_repo_name   = "Customer-Churn-Model-and-Deployment_1-2-MLOps"
  code_commit_location    = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/Customer-Churn-Model-and-Deployment_1-2-MLOps"
  code_pipeline_role      = "arn:aws:iam::516003265142:role/service-role/codebuild-Customer-Churn_1-2-MLOps-service-role"
  ecs_service_role        = "arn:aws:iam::516003265142:role/service-role/codebuild-Customer-Churn_1-2-MLOps-service-role"
  ecs_task_role           = "arn:aws:iam::516003265142:role/service-role/codebuild-Customer-Churn_1-2-MLOps-service-role"
  vpc_id                  = aws_vpc.prod-vpc.id
  tags = {
    application = "churn-prediction"
  }
}