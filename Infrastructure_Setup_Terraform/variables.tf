variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  default     = "ami-0b72821e2f351e396"
}

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t2.micro"
}
