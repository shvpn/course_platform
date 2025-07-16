# ------------------------------------------------------------------------------
# Security Group: EC2 Instance Access Control
# ------------------------------------------------------------------------------
# It acts like a virtual firewall attached to your EC2 instance.



resource "aws_security_group" "ec2_sg" {

  # Name of the security group. Useful for identifying it in the AWS console.
  name   = "${var.project_name}-ec2-sg"

  # The VPC where this security group will be created.
  # Here, it's using the default VPC (from data source in main.tf).
  vpc_id = aws_vpc.main.id

   # --------------------------------------------------------------------------
  # INBOUND RULES (Ingress)
  # --------------------------------------------------------------------------

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"         # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IP address
  }


  # --------------------------------------------------------------------------
  # OUTBOUND RULES (Egress)
  # --------------------------------------------------------------------------

  # Rule: Allow all outbound traffic to the internet.
  # This is needed for the EC2 instance to download packages, updates, etc.

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
