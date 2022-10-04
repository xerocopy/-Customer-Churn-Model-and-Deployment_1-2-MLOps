variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# Example of a list variable
variable "availability_zones" {
  default = ["us-east-1a","us-east-1b"] #, "us-east-1c", "us-east-1d","us-east-1e", "us-east-1f"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "env" {
  description = "Customer Churn Deployment environment"
  default     = "Churn_DevOps_Env"
}


variable "ecs_image_ami" {
  type    = string
  default = "ami-07da26e39622a03dc"
  # run the following command to get the image ami for your region
  # aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended
}

variable "ACCOUNT_ID" {
  description = "aws account id number"
  default     = "516003265142"
}

# variable "container_definition" {
#   type        = string
#   description = "JSON string of container definition assigned to ecs task"
# }