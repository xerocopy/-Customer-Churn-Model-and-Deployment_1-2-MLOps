locals {
  code_build_service_role = aws_iam_role.containerAppBuildProjectRole.arn
  code_commit_repo_name   = "churn-prediction"
  code_commit_location    = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/churn-prediction"
  code_pipeline_role      = aws_iam_role.apps_codepipeline_role.arn
  ecs_service_role        = aws_iam_role.ecs_service_role.arn
  ecs_task_role           = aws_iam_role.ecs_task_role.arn
  vpc_id                  = aws_vpc.prod-vpc.id
  tags = {
  application = "churn-prediction"
  }
}