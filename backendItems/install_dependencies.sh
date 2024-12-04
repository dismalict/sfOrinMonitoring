#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit
fi

# Update package list
echo "Updating package list..."
apt-get update

# Install Chrony
echo "Checking if Chrony is installed..."
if ! dpkg -l | grep -qw chrony; then
    echo "Chrony not found, installing Chrony..."
    sudo apt install -y chrony
    echo "Enabling and starting Chrony service..."
    sudo systemctl enable chronyd
    sudo systemctl start chronyd
    echo "Chrony installed and started successfully."
else
    echo "Chrony is already installed."
fi

# Ensure nano is installed
echo "Checking if nano is installed..."
if ! dpkg -l | grep -qw nano; then
    echo "Nano not found, installing nano..."
    sudo apt install -y nano
else
    echo "Nano is already installed."
fi

# Install pip if not installed
if ! command -v pip &> /dev/null; then
    echo "pip not found, installing..."
    apt-get install -y python3-pip
fi

# Install required Python packages
pip3 install --upgrade \
    mysql-connector-python \
    jetson-stats \
    psutil \
    configparser \
    subprocess32
    
# Ensure other packages is installed
apt-get install -y nano
apt-get install python-is-python3
apt-get upgrade

cp dismalOrinGather.service /etc/systemd/system
systemctl daemon-reload
systemctl enable dismalOrinGather.service
systemctl start dismalOrinGather.service

