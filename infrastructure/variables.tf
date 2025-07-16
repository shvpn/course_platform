# ------------------------------------------------------------------------------
# VARIABLES: Input values used across Terraform configuration
# ------------------------------------------------------------------------------


# AWS Region
# This defines the AWS region where all resources will be created.

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

# Project Name
variable "project_name" {
  description = "Prefix for naming resources"
  type        = string
  default     = "django-course"
}


# AMI ID
# This is the machine image used to launch the EC2 instance.
# Must be provided manually — can be for Ubuntu, Amazon Linux, etc.
variable "ami_id" {
  description = "AMI ID for EC2 (Ubuntu or Amazon Linux)"
  type        = string
}

# EC2 Instance Type
# This defines the hardware specification (CPU/RAM) for the EC2 instance.
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Key Pair Name
# The name of an existing AWS EC2 Key Pair that allows you to SSH into the instance.
variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}

# Subnet ID
# ID of the subnet where the EC2 instance will be launched.
# Must be a public subnet if you want internet access (and public IP).
variable "subnet_id" {
  description = "Subnet to launch the EC2 instance in"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy resources into"
  type        = string
}