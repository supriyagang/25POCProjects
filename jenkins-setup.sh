#!/bin/bash

# Switch to superuser
sudo su

# Update system packages
yum update -y

# Set hostname
hostnamectl set-hostname jenkinserver

# Install necessary packages
yum install -y tar git fontconfig java-17

# Change to /opt directory
cd /opt

# Download Maven and extract it
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
tar -xvf apache-maven-3.9.9-bin.tar.gz

# Rename extracted directory to 'maven'
mv apache-maven-3.9.9 maven


# Download Jenkins repository configuration
echo "Downloading Jenkins repository configuration..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins GPG key
echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
echo "Installing Jenkins..."
yum install jenkins -y


# Add environment variables to .bashrc for persistent settings
echo "Adding environment variables to .bashrc..."
echo -e "\n# Set Java 17 environment variables" >> ~/.bashrc
echo "export PATH=\$PATH:/usr/lib/jvm/java-17-amazon-corretto.x86_64/bin" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64" >> ~/.bashrc

echo "# Set Maven environment variables" >> ~/.bashrc
echo "export PATH=\$PATH:/opt/maven/bin" >> ~/.bashrc
echo "export M2_HOME=/opt/maven" >> ~/.bashrc

echo "# Set Git path" >> ~/.bashrc
echo "export PATH=\$PATH:/usr/bin/git" >> ~/.bashrc


# Check Jenkins status with no pager
echo "Checking Jenkins service status..."
systemctl status jenkins --no-pager

# Start Jenkins service
echo "Starting Jenkins service..."
systemctl start jenkins

# Check Jenkins status again with no pager
echo "Checking Jenkins service status after start..."
systemctl status jenkins --no-pager


# Display the initial admin password
echo "Fetching Jenkins initial admin password..."
cat /var/lib/jenkins/secrets/initialAdminPassword

# Success message
echo "Jenkins has been successfully installed and configured!"
echo "Environment variables have been added to .bashrc. Please run 'source ~/.bashrc' to apply the changes."
