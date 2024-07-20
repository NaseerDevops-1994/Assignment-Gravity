# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# EC2 Instance Type
variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"
}

# AMI ID
variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-0abcdef1234567890"  # Replace with a valid AMI ID
}

# Email for SNS notifications
variable "sns_email" {
  description = "The email address to receive SNS notifications"
  type        = string
}

# IAM Role Name
variable "iam_role_name" {
  description = "The name of the IAM role for EC2"
  type        = string
  default     = "ec2_cloudwatch_role"
}

variable "vpc_id" {
  description = "The ID of the existing VPC"
}

variable "subnet_id" {
  description = "The ID of the existing subnet"
}

variable "security_group_id" {
  description = "The ID of the existing security group"
}