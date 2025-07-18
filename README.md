# Online Course Website Infrastructure Deployment

This repository contains Terraform infrastructure code to deploy Rean Clouds website on AWS. Follow the steps below to set up and deploy the infrastructure.

## Prerequisites

- AWS CLI installed and configured
- Terraform installed (version 1.0 or higher)
- Valid AWS account with appropriate permissions

## Deployment Steps

### 1. Navigate to Infrastructure Directory

```bash
cd infrastructure
```

### 2. Configure AWS Credentials

You need to authenticate with AWS before deploying. You can do this in several ways:

#### Option A: AWS CLI Configure
```bash
aws configure
```
Enter your:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., us-east-1)
- Default output format (json)

#### Option B: Environment Variables
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

#### Option C: AWS Console Login
If using AWS CloudShell or similar, ensure you're logged into the AWS Console with appropriate permissions.

### 3. Initialize Terraform

```bash
terraform init
```

This command downloads the required providers and initializes the working directory.

### 4. Configure Variables

Edit the `terraform.tfvars` file to customize your deployment:

```bash
nano terraform.tfvars
```

Or create the file if it doesn't exist:

```bash
touch terraform.tfvars
```

Update the variables according to your requirements. Here's the complete `terraform.tfvars` configuration:

```hcl
# AWS Configuration
region           = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]

# Environment Configuration
environment      = "production"
project_name     = "online-course"

# EC2 Configuration
instance_type    = "t3.medium"
key_pair_name    = "your-key-pair"
min_size         = 1
max_size         = 3
desired_capacity = 2

# VPC Configuration
vpc_cidr         = "10.0.0.0/16"
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

# Application Configuration
domain_name      = "yourcourse.com"
app_port         = 80
health_check_path = "/"

# Database Configuration (if applicable)
db_instance_class = "db.t3.micro"
db_name          = "coursedb"
db_username      = "admin"
# db_password will be generated automatically

# Tags
tags = {
  Project     = "online-course"
  Environment = "production"
  Owner       = "your-name"
  ManagedBy   = "terraform"
}
```

### 5. Plan the Deployment

Review what Terraform will create:

```bash
terraform plan
```

This shows you all the resources that will be created, modified, or destroyed.

### 6. Apply the Infrastructure

Deploy the infrastructure:

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### 7. Access Your Website

After successful deployment, Terraform will output the Auto Scaling Group (ASG) endpoint. Look for output similar to:

```
Outputs:
asg_endpoint = "your-alb-endpoint-123456789.us-east-1.elb.amazonaws.com"
```

### 8. Open Your Website

Open your web browser and navigate to:

```
http://your-alb-endpoint-123456789.us-east-1.elb.amazonaws.com
```

**Note:** Use `http://` (not `https://`) to access your website initially.

## Important Notes

- The deployment may take 5-10 minutes to complete
- Ensure your AWS account has sufficient permissions to create EC2, VPC, Load Balancer, and Auto Scaling resources
- The endpoint provided is for the Application Load Balancer, which distributes traffic to your instances
- If you encounter any errors, check the Terraform logs and ensure your AWS credentials are properly configured

## Troubleshooting

### Common Issues:

1. **AWS credentials not configured**: Ensure you've completed step 2 correctly
2. **Terraform not found**: Install Terraform from [terraform.io](https://terraform.io)
3. **Permission denied**: Ensure your AWS user has the necessary IAM permissions
4. **Region mismatch**: Verify the region in your `terraform.tfvars` matches your AWS CLI configuration

### Cleanup

To destroy the infrastructure when no longer needed:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction.

## Additional Configuration Files

### variables.tf
Create a `variables.tf` file to define all input variables:

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "online-course"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_pair_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = ""
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "online-course"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### outputs.tf
Create an `outputs.tf` file to display important information after deployment:

```hcl
output "asg_endpoint" {
  description = "Auto Scaling Group Load Balancer endpoint"
  value       = aws_lb.main.dns_name
}

output "asg_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.main.arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "load_balancer_dns" {
  description = "Load Balancer DNS name"
  value       = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  description = "Load Balancer Zone ID"
  value       = aws_lb.main.zone_id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.web.id
}

output "website_url" {
  description = "Website URL"
  value       = "http://${aws_lb.main.dns_name}"
}
```

### .gitignore
Create a `.gitignore` file to exclude sensitive files:

```gitignore
# Terraform files
*.tfstate
*.tfstate.*
*.tfvars
.terraform/
.terraform.lock.hcl

# AWS credentials
.aws/
*.pem
*.key

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Log files
*.log
```