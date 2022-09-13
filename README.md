# Customer-Churn-Model-and-Deployment_1-2-MLOps
This is the deployment repository for Customer-Churn-Project.

### Description

### Technology

### Assets:

### Model Deployment Steps:

1. Code commit Repository

    - create CodeCommit repository
    
    - push the code from c9 to CodeCommit Repository (keep the code updated)

2. AWS ECR
    - create container in aws ECR repository
    - 
    - in cloud9, create image following the push commmands instruction in aws ECR
    - 
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
        - 
    

3. AWS Code Build

    - create CodeBuild project with older enviornment image to avoid issue in prebuild aws/codebuild/amazonlinux2-x86_64-standard:2.0 (use codebuild push docker image to ecr)
    
    - write the buildspec.yaml file 
    
    - make sure to attach AmazonEC2ContainerRegistryFullAccess permission to the codebuild service role
    
    - one need to update the ECR permission policy to allow access (https://docs.aws.amazon.com/codebuild/latest/userguide/sample-ecr.html)


4. Importing resources to Terraform/ Terrraform commands and console

5. AWS Load Balancer

6. AWS ECS cluster

7. AWS ECS service and code pipeline

8. Code pipeline demo

9. AWS s3 bucket

