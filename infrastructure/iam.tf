# ------------------------------------------------------------------------------
# IAM Role: EC2 Instance Access to AWS Services
# ------------------------------------------------------------------------------


# IAM Role that allows EC2 instances to assume certain AWS permissions.
# In this case, the permissions will be related to accessing S3 buckets.

resource "aws_iam_role" "ec2_role" {
  
  # Name of the IAM role (helpful for identifying in the AWS console)
  name = "${var.project_name}-ec2-role"
  
  # This policy defines which AWS service is allowed to assume this role.
  # Here, only EC2 is allowed to use it.
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com" # Only EC2 instances can assume this role
      },
      Action = "sts:AssumeRole"
    }]
  })
}


# ------------------------------------------------------------------------------
# IAM Role Policy Attachment: Grant S3 Full Access to EC2 Role
# ------------------------------------------------------------------------------

# This attaches the AWS managed policy "AmazonS3FullAccess" to the EC2 role.
# It allows the EC2 instance to interact with S3 buckets — upload, download, list, etc.
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# This is what you attach to the EC2 instance so it can use the IAM role's permissions.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}


# senghout user
resource "aws_iam_user" "senghout" {
  name = "senghout"
  path = "/"
  tags = {
    Name = "Senghout"
  }
}

resource "aws_iam_access_key" "senghout_key" {
  user = aws_iam_user.senghout.name
}

# panha user
resource "aws_iam_user" "panha" {
  name = "panha"
  path = "/"
  tags = {
    Name = "Panha"
  }
}

resource "aws_iam_access_key" "panha_key" {
  user = aws_iam_user.panha.name
}

# OUTPUTS
output "senghout_username" {
  value = aws_iam_user.senghout.name
}

output "senghout_user_id" {
  value = aws_iam_user.senghout.unique_id
}

output "senghout_access_key_id" {
  value     = aws_iam_access_key.senghout_key.id
  sensitive = true
}

output "senghout_secret_access_key" {
  value     = aws_iam_access_key.senghout_key.secret
  sensitive = true
}

output "panha_username" {
  value = aws_iam_user.panha.name
}

output "panha_user_id" {
  value = aws_iam_user.panha.unique_id
}

output "panha_access_key_id" {
  value     = aws_iam_access_key.panha_key.id
  sensitive = true
}

output "panha_secret_access_key" {
  value     = aws_iam_access_key.panha_key.secret
  sensitive = true
}
