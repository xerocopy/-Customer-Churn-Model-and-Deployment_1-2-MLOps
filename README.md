# Customer-Churn-Model-and-Deployment_1-2-MLOps
This is the deployment repository for Customer-Churn-Project.

### Description

### Technology

### Assets:

### Roles: 
        - codebuild-Customer-Churn_1-2-MLOps-service-role
        
        trust relationship:
                {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Service": ["codebuild.amazonaws.com" ,
				"codepipeline.amazonaws.com"]
			},
			"Action": "sts:AssumeRole"
		}
	]
}

### Model Deployment Steps:

1. Code commit Repository

    - create CodeCommit repository
    
    - push the code from c9 to CodeCommit Repository (keep the code updated)

2. AWS ECR
    - create container in aws ECR repository
    
    - in cloud9, create image following the push commmands instruction in aws ECR
    
    -   1. create and workd in a virtual enviornment if not already in one: 
   
            - python3 -m venv ./VENV         
            
            - source VENV/bin/activate
  
        2. Retrieve an authentication token and authenticate your Docker client to your registry.Use the AWS CLI:
        
            - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 516003265142.dkr.ecr.us-east-1.amazonaws.com
        
        2. Build your Docker image using the following command. For information on building a Docker file from scratch, see the instructions here . You can skip this step if your image has already been built:
            
            - docker build -t customerchurnprediction .
        
        3. After the build is completed, tag your image so you can push the image to this repository:
        
            - docker tag customerchurnprediction:latest 516003265142.dkr.ecr.us-east-1.amazonaws.com/customerchurnprediction:latest
        
        4. Run the following command to push this image to your newly created AWS repository:
        
            - docker push 516003265142.dkr.ecr.us-east-1.amazonaws.com/customerchurnprediction:latest
        

3. AWS Code Build

    - create CodeBuild project with older enviornment image to avoid issue in prebuild aws/codebuild/amazonlinux2-x86_64-standard:2.0 (use codebuild push docker image to ecr)
    
    - remember to tick 'Enable this flag if you want to build Docker images or want your builds to get elevated privileges.'
    
    - write the buildspec.yaml file 
    
    - make sure to attach AmazonEC2ContainerRegistryFullAccess permission to the codebuild service role
    
    - one need to update the ECR permission policy to allow access (https://docs.aws.amazon.com/codebuild/latest/userguide/sample-ecr.html)


4. Importing resources to Terraform/ Terrraform commands and console (IaC)
        
    - install terraform in aws c9 [Complete Tutorial for Terraform](https://www.youtube.com/watch?v=SLB_c_ayRMo&t=5774s)
    
        - sudo yum install -y yum-utils
        
        - sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
        
        - sudo yum -y install terraform
        
        - write the terraform files [terraform templates for resources are available here](https://www.terraform.io/language/resources/syntax)
        
        - terraform init
        
        - terraform plan  #supervise the details
        
        - terraform apply (yes)
        
        - terraform destroy
        
    - configure aws credentials [Best practises to use credentials in terraform](https://www.youtube.com/watch?v=36Ug1Sq3TWs&t=971s)
    
        - aws configure --profile ML_DevOps_User     
        
        - export AWS_ACCESS_KEY_ID="*****************"
        - export AWS_SECRET_ACCESS_KEY="****************************"
        
        - aws configure list #list the configure of the credentials, confirm the correct access_key and secret_key
    
    - Terraform backend s3 configuration 
        

5. AWS Load Balancer
    - Set up ECS Fargat with [a load balancer in aws](https://www.youtube.com/watch?v=o7s-eigrMAI)
    - in this project LB is setup with terraform 

6. AWS ECS cluster

    - in this project LB is setup with terraform

7. AWS ECS service and code pipeline



8. Code pipeline demo



9. AWS s3 bucket for terraform backend 

    - [see how to set up terraform remote backend with aws s3](https://www.youtube.com/watch?v=FTgvgKT09qM)


10. ingore the .terraform folder to avoid large file before push to the repo

   - git filter-branch -f --index-filter 'git rm --cached -r --ignore-unmatch .terraform/'




########

testing the flask app 

    - pip install -r requirements.txt
    
    - python app.py

#######
