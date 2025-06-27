#!/bin/bash

# Step 1: Clone the repo (if not already cloned)
if [ ! -d "devops_assignment" ]; then
    echo "Cloning repository..."
    git clone https://github.com/NishitaNJ/devops_assignment.git
else
    echo "Repository already exists. Pulling latest changes..."
    cd devops_assignment
    git pull
    cd ..
fi

# Step 2: Change directory into the repo
cd devops_assignment

# Step 3: Build the Docker image
echo "Building Docker image..."
docker build -t flask-ec2-app .

# Step 4: Run the container
echo "Running the Flask app container..."
docker run -d -p 5000:5000 flask-ec2-app
