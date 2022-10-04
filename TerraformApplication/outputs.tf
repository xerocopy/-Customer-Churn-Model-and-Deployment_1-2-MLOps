output "churn_repo_clone_url_http" {
  value       = aws_codecommit_repository.churn_repo.clone_url_http
  description = "The private IP address of the main server instance."
}

output "churn_repo_clone_url_ssh" {
  value       = aws_codecommit_repository.churn_repo.clone_url_ssh
  description = "The private IP address of the main server instance."
}


output "churn_application_url" {
  value       = format("http://%s:5000", aws_lb.churn_load_balancer.dns_name)
  description = "Churn application's URL"
}


