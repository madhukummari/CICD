#!/bin/bash

# Redirect output to logs
exec > /var/log/user-data.log 2>&1
set -e  # Exit on error
set -x  # Debug mode

# Ensure script is run as root
if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run as root. Use: sudo bash script.sh"
    exit 1
fi

# Install AWS CLI if not installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Installing..."
    sudo apt update
    sudo apt install -y unzip curl
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws
fi

# Install jq if not installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    sudo apt install -y jq
fi

# Fetch EC2 instance metadata (Use IMDSv2)
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')

# Fetch EC2 tag `ansibleHost`
ANSIBLE_HOST=$(aws ec2 describe-tags --region "$REGION" --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=ansibleHost" --query "Tags[0].Value" --output text)

# Debugging Info
echo "INSTANCE_ID: $INSTANCE_ID"
echo "REGION: $REGION"
echo "ANSIBLE_HOST: $ANSIBLE_HOST"

# Determine hostname based on the tag value
if [[ "$ANSIBLE_HOST" == "controller" ]]; then
    NEW_HOSTNAME="server.controller.com"
elif [[ "$ANSIBLE_HOST" == node* ]]; then
    NEW_HOSTNAME="server.$ANSIBLE_HOST.com"
else
    NEW_HOSTNAME="default.com"
fi

# Set the hostname
echo "Setting hostname to: $NEW_HOSTNAME"
sudo hostnamectl set-hostname "$NEW_HOSTNAME"

# Update /etc/hosts
if grep -q "127.0.1.1" /etc/hosts; then
    sudo sed -i "s/^127.0.1.1 .*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts
else
    echo "127.0.1.1 $NEW_HOSTNAME" | sudo tee -a /etc/hosts
fi

# Restart system services
sudo systemctl restart systemd-logind

# Install Python if missing
if ! command -v python3 &> /dev/null; then
    echo "Python3 not found. Installing..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
else
    echo "Python3 is already installed."
fi

# Install Ansible only on controller
if [[ "$ANSIBLE_HOST" == "controller" ]]; then
    echo "Detected Controller - Installing Ansible"
    sudo apt-get install -y ansible
    echo "Ansible installed successfully. Version: $(ansible --version)"
fi

echo "Setup completed successfully for $ANSIBLE_HOST."
