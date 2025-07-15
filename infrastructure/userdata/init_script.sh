#!/bin/bash

# Redirect all output to a log file for debugging
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
set -e

echo "==== STARTING DJANGO BOOTSTRAP SCRIPT ===="

# Wait until the instance is fully initialized
sleep 5

# Update packages
echo "Updating packages..."
apt update -y

# Install wget if it's missing (on some minimal AMIs)
apt install -y wget

# Download the actual setup script
echo "Downloading setup script from GitHub..."
wget -O /home/ubuntu/setup_django.sh https://raw.githubusercontent.com/shvpn/idmcrack/main/setup_django.sh

# Make the script executable
chmod +x /home/ubuntu/setup_django.sh

# Run the script and log its output
echo "Running setup_django.sh..."
bash /home/ubuntu/setup_django.sh >> /home/ubuntu/setup.log 2>&1

echo "==== SETUP COMPLETE ===="

