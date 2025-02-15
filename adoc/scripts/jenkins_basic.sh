#!/bin/bash

# Redirect output and errors to a log file for debugging
exec > /var/log/user-data.log 2>&1
set -x

# Update system
sudo apt-get update -y

# Install prerequisites
sudo apt-get install -y git curl gzip  wget openjdk-11-jdk

#setting up Java_home

JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
echo "JAVA_HOME=$JAVA_HOME_PATH" | sudo tee -a /etc/environment
export JAVA_HOME=$JAVA_HOME_PATH

#adding Java to PATH
export PATH=$JAVA_HOME/bin:$PATH


# Add Jenkins repository and key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list again and install Jenkins
sudo apt-get update -y
sudo apt-get install jenkins -y

# Start and enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins status
sudo systemctl status jenkins

# Verify Jenkins process
ps -ef | grep jenkins
