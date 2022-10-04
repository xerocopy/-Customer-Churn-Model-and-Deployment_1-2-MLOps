# Customer-Churn-Model-and-Deployment_1-2-MLOps

This is the deployment repository for Customer-Churn-Project.

### Description
Deploy the customer-churn web app using flaskapi, gunicorn and terraform. 

### Key Technologies

Flask API, Terraform, CodeCommit, CodeBuild, CodePipeline, Fargate, ECS, ECR, IAM, vpc, gateway, loadbalancer, subnet, security groups, etc..

### Assets:

TerraformApplication folder

FlaskApplication folder

### Roles: 

see /TerraformApplication/iam_role.tf

### Application architecture: 

[!alt text](https://github.com/xerocopy/Customer-Churn-Model-and-Deployment_2-2-MLOps/blob/ce83799cc4978814de2483bbefacddfefac6f094/img/Churn_architecture.png)

### Steps of Model Deployment

### 1. Test the flask app and prepare the src folder for code commit

	- python3 -m venv .venv
	
	- source .venv/bin/activate
	
	- pip install -r requirements.txt
    
    	- python Engine.py
    
    	- python app.py
    
    	- bash gunicorn.sh  
	
### 2.  Test docker image/container in local environment and prepare the buildspec.yaml for code build
	
	- create src/logs/error.log

	- docker build .
	
	- docker image ls
	
	- docker run 'image_id'
	
	-docker container ls
	
	-docker top 'container_id'

	
 	AWS ECR and buildspec.yaml file preparation 
    	
	- create container in aws ECR repository
    
   	- in cloud9, create image following the push commmands instruction in aws ECR
    
    	 1. create and workd in a virtual enviornment if not already in one: 
   
            - python3 -m venv ./VENV         
            
            - source VENV/bin/activate
  
         2. Retrieve an authentication token and authenticate your Docker client to your registry.Use the AWS CLI:
        
            - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 516003265142.dkr.ecr.us-east-1.amazonaws.com
        
         3. Build your Docker image using the following command. For information on building a Docker file from scratch, see the instructions here . You can skip this step if your image has already been built:
            
            - docker build -t churn-application-repo .
        
         4. After the build is completed, tag your image so you can push the image to this repository:
        
            - docker tag churn-application-repo:latest 516003265142.dkr.ecr.us-east-1.amazonaws.com/churn-application-repo:latest
        
         5. Run the following command to push this image to your newly created AWS repository:
        
            - docker push 516003265142.dkr.ecr.us-east-1.amazonaws.com/churn-application-repo:latest
 
 
### 3. AWS Infrustracture and CI/CD pipeline construction via Terraform (automation):
    
   -Importing resources to Terraform/ Terrraform commands and console (IaC)
        
    - install terraform in aws c9 [Complete Tutorial for Terraform](https://www.youtube.com/watch?v=SLB_c_ayRMo&t=5774s)
    
        - sudo yum install -y yum-utils
        
        - sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
        
        - sudo yum -y install terraform
        
    - write the terraform files [terraform templates for resources are available here](https://www.terraform.io/language/resources/syntax)
        
    - Execute terraform commands
    
	- terraform init
        
        - terraform plan  #review the details
        
        - terraform apply (yes/ -- auto approve)
        
        - terraform destroy
        
    - configure aws credentials [Best practises to use credentials in terraform](https://www.youtube.com/watch?v=36Ug1Sq3TWs&t=971s)
    
        - aws configure --profile ML_DevOps_User     
        
        - export AWS_ACCESS_KEY_ID="*****************"
        - export AWS_SECRET_ACCESS_KEY="****************************"
        
        - aws configure list #list the configure of the credentials, confirm the correct access_key and secret_key
    
    - Terraform backend s3 configuration (see /TerraformApplication/provider.tf)
        
    - delete the .terraform folder and reinitialise git 'git init' to avoid large file before push to the repo
       

### 4.  update code via git push to the codecommit repository and run the pipeline on aws



#### References: 

1. [!How to input url for flask](https://www.askpython.com/python-modules/flask/flask-forms)

2. [!CI CD Pipeline on AWS with CodePipeline, ECS and Terraform](https://www.youtube.com/watch?v=PnGqOnp6mE4)

3. [ECS Fargate Terraform Networkconfigurations](https://www.youtube.com/watch?v=_LIZR9ghjP8v)

4. [Trouble shooting for network - aws-ecs-fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry](https://stackoverflow.com/questions/61265108/aws-ecs-fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry)

5. [Trouble shooting for network - documents](https://aws.amazon.com/blogs/containers/aws-fargate-launches-platform-version-1-4/)

6. [ECS terraform with cloudwatch setup](https://www.youtube.com/watch?v=SVMTorsNrWg)

7. [!Configure Cloudwatch logs](https://www.youtube.com/watch?v=Y_FxbQmY3l8)

8. [Docker RUN vs CMD vs Entry vs Point](https://www.bmc.com/blogs/docker-cmd-vs-entrypoint/)

9. [!ECS Fargate ELB](https://www.youtube.com/watch?v=o7s-eigrMAI&t=1239s)

10. [General Tutorial Flask and Postman](https://www.youtube.com/watch?v=HxLm-kZlXgU)

11. [!Very good flask tutorial video list - inc. http methods](https://www.youtube.com/watch?v=9MHYHgh4jYc)]

12. [Python Flask Tutorial API - How To Get Data From An API With Flask](https://www.youtube.com/watch?v=F_SBxcV335k)

13. [!CI/CD With AWS ECS + CodePipeline + CodeDeploy + CodeCommit + CodeBuild + Docker](https://www.youtube.com/watch?v=d7PTjQiahOQ&list=PLMDIq4U4quFzL-k-RnaaFufi1YGBuC7Wg&index=6&t=2545s)

14. [other terraform resources:](https://www.youtube.com/watch?v=7xngnjfIlK4) 

15. [see how to set up terraform remote backend with AWS S3](https://www.youtube.com/watch?v=FTgvgKT09qM)

16. [Set up ECS Fargat with a load balancer in aws](https://www.youtube.com/watch?v=o7s-eigrMAI)

### Supplymentary and trouble shoots

	1. Aws ecs fargate ResourceInitializationError: unable to pull secrets or registry auth

		Launch tasks into a public subnet, with a public IP address, so that they can communicate to ECR and other backing services using an internet gateway

		Launch tasks in a private subnet that has a VPC routing table configured to route outbound traffic via a NAT gateway in a public subnet. This way the NAT gateway can open a connection to ECR on behalf of the task.

		Launch tasks in a private subnet and make sure you have AWS PrivateLink endpoints configured in your VPC, for the services you need (ECR for image pull authentication, S3 for image layers, and AWS Secrets Manager for secrets).

	2. target group status unhealthy

		-allow plenty of response time when building/registering subnets

		-allow security group access between loadbalancer and ecs

