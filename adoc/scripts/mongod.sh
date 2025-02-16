#!/bin/bash

# Update package list and upgrade packages
sudo apt update && sudo apt upgrade -y

# Import MongoDB public GPG key
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-keyring.gpg

# Add MongoDB repository
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-keyring.gpg] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

# Update package list again
sudo apt update

# Install MongoDB
sudo apt install -y mongodb-org

# Start and enable MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Verify installation
sudo systemctl status mongod


#netstat -tulnp | grep 27017
#tcp  0  0  0.0.0.0:27017  0.0.0.0:*  LISTEN  1234/mongod {expected listing to all}
#tcp        0      0 127.0.0.1:27017         0.0.0.0:*               LISTEN      -  [only listing on the server]
#  -> sudo vi /etc/mongod.conf
# Find this section and update the bindIp:
# net:
#   port: 27017
#   bindIp: 0.0.0.0  # Allows connections from any IP


# Restart MongoDB:
# sudo systemctl restart mongod
# Test External Connection
# Run this from your application server:

# mongo --host 54.224.178.100 --port 27017 --eval "db.adminCommand('ping')"

# sudo journalctl -u mongod --no-pager | tail -n 20
# sudo tail -f /var/log/mongodb/mongod.log
# sudo cat /var/log/mongodb/mongod.log | tail -n 20
# from local mongosh "mongodb://mongodb-user:adminpassword@54.158.55.94:27017/stationary_db"

