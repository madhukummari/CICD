#!/bin/bash

# Redirect output and errors to a log file
exec > /var/log/user-data.log 2>&1
set -x  # execute in de-bug mode
set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

# Constants
JENKINS_KEYRING="/usr/share/keyrings/jenkins-keyring.asc"
JENKINS_LIST="/etc/apt/sources.list.d/jenkins.list"
JAVA_HOME_PATH="/usr/lib/jvm/java-21-openjdk-amd64"

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install essential tools
echo "Installing dependencies..."
sudo apt-get install -y git curl gzip wget openjdk-21-jdk net-tools 

# Set JAVA_HOME path
echo "Configuring JAVA_HOME..."
if [ -d "$JAVA_HOME_PATH" ]; then
    echo "JAVA_HOME=$JAVA_HOME_PATH" | sudo tee -a /etc/environment
    export JAVA_HOME=$JAVA_HOME_PATH
    export PATH=$JAVA_HOME/bin:$PATH
else
    echo "Java installation directory not found. Exiting."
    exit 1
fi

# Verify Java installation
echo "Checking Java installation..."
if ! java -version &> /dev/null; then
    echo "Java installation failed. Exiting."
    exit 1
fi

# Add Jenkins repository key
echo "Adding Jenkins repository key..."
sudo wget -O $JENKINS_KEYRING https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "Adding Jenkins repository..."
echo "deb [signed-by=$JENKINS_KEYRING] https://pkg.jenkins.io/debian-stable binary/" | sudo tee $JENKINS_LIST > /dev/null

# Update repositories
echo "Updating repositories..."
sudo apt-get update -y

# Set non-interactive mode to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install -y jenkins

# Enable and start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl enable jenkins

sudo systemctl start jenkins

# Verify Jenkins service
if systemctl is-active --quiet jenkins; then
    echo "Jenkins is running successfully."
else
    echo "Jenkins failed to start. Check logs for details."
    exit 1
fi

# Output Jenkins initial admin password
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
