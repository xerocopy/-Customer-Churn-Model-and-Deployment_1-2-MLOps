# Customer-Churn-Model-and-Deployment_1-2-MLOps
This is the deployment repository for Customer-Churn-Project.

### Description

### Key Technologies

Flask API, Terraform, CodeCommit, CodeBuild, CodePipeline, Fargate,
ECS, ECR, IAM, vpc, gateway, loadbalancer, subnet, security groups

	
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
                "Service": [
                    "codepipeline.amazonaws.com",
                    "codebuild.amazonaws.com",
                    "ecs-tasks.amazonaws.com",
                    "ecs.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}


### Steps of Model Deployment


### 1. Test the flask app and docker image/container

    - pip install -r requirements.txt
    
    - python Engine.py
    
    - python app.py
    
    - bash gunicorn.sh
    
    

### 2. Infrustracture construction via Terraform:

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
            
            - docker build -t churn-application-repo .
        
        3. After the build is completed, tag your image so you can push the image to this repository:
        
            - docker tag churn-application-repo:latest 516003265142.dkr.ecr.us-east-1.amazonaws.com/churn-application-repo:latest
        
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
        
    - Execute terraform commands
    
	- terraform init
        
        - terraform plan  #supervise the details
        
        - terraform apply (yes/ -- auto approve)
        
        - terraform destroy
        
    - configure aws credentials [Best practises to use credentials in terraform](https://www.youtube.com/watch?v=36Ug1Sq3TWs&t=971s)
    
        - aws configure --profile ML_DevOps_User     
        
        - export AWS_ACCESS_KEY_ID="*****************"
        - export AWS_SECRET_ACCESS_KEY="****************************"
        
        - aws configure list #list the configure of the credentials, confirm the correct access_key and secret_key
    
    - Terraform backend s3 configuration 
    
    - after the infrastructure been built, push the container to the ECR
    
    - delete the .terraform folder and reinitialise git 'git init' to avoid large file before push to the repo
       

5. AWS Load Balancer

    - Set up ECS Fargat with [a load balancer in aws](https://www.youtube.com/watch?v=o7s-eigrMAI)
    
    - in this project LB is setup with terraform 

6. AWS ECS cluster

    - in this project LB is setup with terraform

7. AWS ECS service and code pipeline


8. Code pipeline demo


[other terraform resources:](https://www.youtube.com/watch?v=7xngnjfIlK4) 



9. AWS s3 bucket for terraform backend 

    - [see how to set up terraform remote backend with aws s3](https://www.youtube.com/watch?v=FTgvgKT09qM)



### 3. CI/CD pipeline construction and automation


test the the newly build container on local machine 
create src/logs/error.log

docker build .
docker image ls
docker run 'image_id'
docker container ls
docker top 'container_id'


Docker build and Model serving 
	build the docker and push image to the ECR 


run code pipeline from code commit




trouble shooting:

There are a few ways to solve this:

Launch tasks into a public subnet, with a public IP address, so that they can communicate to ECR and other backing services using an internet gateway

Launch tasks in a private subnet that has a VPC routing table configured to route outbound traffic via a NAT gateway in a public subnet. This way the NAT gateway can open a connection to ECR on behalf of the task.

Launch tasks in a private subnet and make sure you have AWS PrivateLink endpoints configured in your VPC, for the services you need (ECR for image pull authentication, S3 for image layers, and AWS Secrets Manager for secrets).





allow security group for loadbalancer



#### References: 

4. [!How to input url for flask](https://www.askpython.com/python-modules/flask/flask-forms)

6. [!CI CD Pipeline on AWS with CodePipeline, ECS and Terraform](https://www.youtube.com/watch?v=PnGqOnp6mE4)

7. [ECS Fargate Terraform Networkconfigurations](https://www.youtube.com/watch?v=_LIZR9ghjP8v)


8. [Trouble shooting for network - aws-ecs-fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry](https://stackoverflow.com/questions/61265108/aws-ecs-fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry)

9. [Trouble shooting for network - documents](https://aws.amazon.com/blogs/containers/aws-fargate-launches-platform-version-1-4/)


10. [ECS terraform with cloudwatch setup](https://www.youtube.com/watch?v=SVMTorsNrWg)

11. [!Configure Cloudwatch logs](https://www.youtube.com/watch?v=Y_FxbQmY3l8)

12. [Docker RUN vs CMD vs Entry vs Point](https://www.bmc.com/blogs/docker-cmd-vs-entrypoint/)

13. [!ECS Fargate ELB](https://www.youtube.com/watch?v=o7s-eigrMAI&t=1239s)



not in use

1. [General Tutorial Flask and Postman](https://www.youtube.com/watch?v=HxLm-kZlXgU)

2. [!Very good flask tutorial video list - inc. http methods](https://www.youtube.com/watch?v=9MHYHgh4jYc)]

3. [Python Flask Tutorial API - How To Get Data From An API With Flask](https://www.youtube.com/watch?v=F_SBxcV335k)


5. [!CI/CD With AWS ECS + CodePipeline + CodeDeploy + CodeCommit + CodeBuild + Docker](https://www.youtube.com/watch?v=d7PTjQiahOQ&list=PLMDIq4U4quFzL-k-RnaaFufi1YGBuC7Wg&index=6&t=2545s)








