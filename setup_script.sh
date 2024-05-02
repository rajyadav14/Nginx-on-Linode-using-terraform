#!/bin/bash

# Ensure the script is run with root privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Step 1: Install Docker if not already installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Installing Docker now..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo "Docker installed successfully!"
fi

# Step 2: Clone the GitHub repository containing the website files to a temporary directory
# Replace 'https://github.com/siddhantbhattarai/e-commerce-static-site.git' with your actual GitHub repository URL
git clone https://github.com/siddhantbhattarai/e-commerce-static-site.git /tmp/website

# Step 3: Copy the website files to a permanent directory
mkdir -p /var/www/my-website
cp -R /tmp/website/* /var/www/my-website

# Step 4: Build the Docker image for Nginx with the website files
docker build -t nginx /var/www/my-website

# Step 5: Run Nginx container from the built image
docker run -it --rm -d -p 8080:80 --name web nginx

# Step 6: Remove temporary website files
rm -rf /tmp/website

# Display a success message
echo "Nginx is now hosting the website and running in a Docker container!"

