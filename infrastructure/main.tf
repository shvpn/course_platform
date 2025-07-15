# ------------------------------------------------------------------------
# Terraform Block
# ------------------------------------------------------------------------

# This block sets the minimum required Terraform version and the AWS provider version.
# The AWS provider is what lets Terraform interact with AWS services like EC2, S3, VPC, etc.

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# ------------------------------------------------------------------------
# Provider Block
# ------------------------------------------------------------------------

# This block configures the AWS provider.
# It tells Terraform to connect to AWS in a specific region (defined in terraform.tfvars).

provider "aws" {
  region = var.aws_region
}


#------------------------------------------------------------------------
# Data Source: Default VPC
# ------------------------------------------------------------------------

# This block retrieves information about the default VPC in the selected AWS region.
# The default VPC is automatically created by AWS in every region, and includes subnets, route tables, etc.
# This is useful for quick deployment without creating a custom VPC (which you may later switch to).
# Load the default VPC and Subnets for now

#data "aws_vpc" "default" {
#  default = true
#}


# ------------------------------------------------------------------------
# Data Source: Default Subnets in the Default VPC
# ------------------------------------------------------------------------

# This block retrieves all subnets associated with the default VPC.
# These subnets are needed to launch EC2 instances or configure a load balancer.


#data "aws_subnets" "default" {
#  filter {
#    name   = "vpc-id"
#    values = [data.aws_vpc.default.id]
#  }
#}
