resource "aws_codecommit_repository" "churn_repo" {
  repository_name = "Customer-Churn-Model-and-Deployment_1-2-MLOps"
  description     = "Repository contains churn prediction application"
  default_branch  = "master"
  tags = {
    application = "churn-prediction"
  }
}


output "churn_repo_clone_url_http" {
  value       = aws_codecommit_repository.churn_repo.clone_url_http
  description = "The private IP address of the main server instance."
}

output "churn_repo_clone_url_ssh" {
  value       = aws_codecommit_repository.churn_repo.clone_url_ssh
  description = "The private IP address of the main server instance."
}