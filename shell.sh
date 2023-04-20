#!/bin/bash

# Define variables
PASSWORD=$(openssl rand -base64 12)
CURRENT_TIME=$(date +%Y-%m-%d_%H-%M-%S)

# Install updates and upgrade current packages
sudo apt update && sudo apt upgrade -y

# Clean up unused packages and dependencies
sudo apt autoremove -y && sudo apt autoclean

# Create a backup of important system files
sudo tar -cvpzf /home/backup/system_$CURRENT_TIME.tar.gz /etc /var/www /var/lib/mysql

# Create a new user and password
read -p 'Enter username: ' NEW_USER
sudo adduser $NEW_USER
echo "$NEW_USER:$PASSWORD" | sudo chpasswd

# Create a new SSH key pair for the user
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<< ""$'\n'"y" 2>&1 >/dev/null

# Print out the new user, password, and SSH key
echo "New user: $NEW_USER"
echo "Password: $PASSWORD"
echo "SSH key:"
cat ~/.ssh/id_rsa.pub
