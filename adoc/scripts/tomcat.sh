#!/bin/bash

# Redirect output and errors to a log file
exec > /var/log/user-data.log 2>&1  #stdout by default file descriptor 1 --> file descriptor 2 is for stderr ==> 1 and 2 to same logs
set -x  # Execute in debug mode
set -e  # Exit immediately if a command exits with a non-zero status

# Update the system
sudo apt-get update -y

# Install OpenJDK 21
sudo apt-get install -y openjdk-21-jdk

# Set JAVA_HOME environment variable
JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which java))))
echo "JAVA_HOME=${JAVA_HOME_PATH}" | sudo tee -a /etc/environment
echo "export JAVA_HOME=${JAVA_HOME_PATH}" >> ~/.bashrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

# Variables for Tomcat version
TOMCAT_VERSION=10.1.35
TOMCAT_URL=https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Download and Install Apache Tomcat
wget ${TOMCAT_URL} -P /tmp

# Extract Tomcat to /opt directory
sudo tar -xzf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt
sudo mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Update permissions for Tomcat scripts
sudo chmod +x /opt/tomcat/bin/*.sh

# Modify tomcat-users.xml to add users with roles
sudo tee /opt/tomcat/conf/tomcat-users.xml > /dev/null <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
               version="1.0">
  <!-- User with manager-gui role for GUI access -->
  <user username="admin" password="admin123" roles="manager-gui,admin-gui"/>
</tomcat-users>
EOL

# Start Tomcat server
sudo /opt/tomcat/bin/startup.sh

# Configure Tomcat as a service
cat <<EOT | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking
Environment=JAVA_HOME=${JAVA_HOME_PATH}
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
User=root
Group=root
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd, enable and start Tomcat as a service
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Clean up
rm -f /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Print Tomcat Access URL
echo "Apache Tomcat ${TOMCAT_VERSION} is installed and running. Access it at: http://$(curl -s ifconfig.me):8080"
