#!/bin/bash

exec > /var/log/user-data.log 2>&1
set -x  # execute in de-bug mode
# Exit on error
set -e

# Function to check if MongoDB is installed
check_mongo_installed() {
    if ! command -v mongod &> /dev/null; then
        echo "🔹 MongoDB is not installed. Installing..."
        install_mongo
    else
        echo "✅ MongoDB is already installed."
    fi
}

# Function to install MongoDB on Ubuntu
install_mongo() {
    echo "🔹 Installing MongoDB..."
    sudo apt update
    sudo apt install -y mongodb
    echo "✅ MongoDB installed successfully."
}

# Function to start MongoDB service
start_mongo() {
    echo "🔹 Starting MongoDB..."
    sudo systemctl start mongodb
    sudo systemctl enable mongodb
    echo "✅ MongoDB started and enabled on boot."
}

# Function to insert sample data
insert_data() {
    echo "🔹 Inserting sample data into MongoDB..."
    
    # Insert sample data into the database
    mongo stationary_db --eval '
    db.products.insertMany([
        { "name": "Pen", "price": 1.5 },
        { "name": "Notebook", "price": 2.0 },
        { "name": "Eraser", "price": 0.5 },
        { "name": "Pencil", "price": 1.0 },
        { "name": "Sharpener", "price": 0.75 },
        { "name": "Ruler", "price": 1.25 },
        { "name": "Marker", "price": 2.5 },
        { "name": "Sketchbook", "price": 5.0 },
        { "name": "Glue Stick", "price": 1.8 },
        { "name": "Stapler", "price": 3.0 },
        { "name": "Scissors", "price": 2.5 },
        { "name": "Highlighter", "price": 1.75 },
        { "name": "Graph Paper", "price": 3.5 },
        { "name": "File Folder", "price": 2.2 }
    ])
    '
    echo "✅ Data inserted successfully."
}

# Main script execution
check_mongo_installed
start_mongo
insert_data

echo "🎉 MongoDB setup completed!"
