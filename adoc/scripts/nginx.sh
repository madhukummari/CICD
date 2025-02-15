#!/bin/bash

# Redirect output and errors to a log file
exec > /var/log/user-data.log 2>&1
set -x  # execute in de-bug mode
set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error


apt-get update
apt-get install -y git curl wget tree net-tools
apt-get install -y nginx

systemctl enable nginx
systemctl restart nginx
systemctl status nginx

echo " execution completed"



# Generate SSH key:
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/jenkins_key
#copy content of jenkins_key.pub manually to targetserver's (append) authorised_keys



