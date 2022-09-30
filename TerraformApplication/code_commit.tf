resource "aws_codecommit_repository" "churn_repo" {
  repository_name = "churn-prediction"
  description     = "Repository contains churn prediction application"
  # default_branch  = "main"
  tags = {
    application = "churn-prediction"
  }
}


resource "null_resource" "image" {

  provisioner "local-exec" {
    command     = <<EOF
       git init
       git add .
       git commit -m "Initial Commit"
       git remote add origin ${aws_codecommit_repository.churn_repo.clone_url_http}
       git push -u origin master
   EOF
    working_dir = "../FlaskApplication/src" #"python_app"
  }
  depends_on = [
    aws_codecommit_repository.churn_repo,
  ]

}

resource "null_resource" "clean_up" {

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOF
       rm -rf .git/
   EOF
    working_dir = "../FlaskApplication/src" #"python_app"

  }
}