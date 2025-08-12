#!/bin/bash
# On EC2 server check the result of this script at /var/log/cloud-init-output.log

# This file is store on EC2 at /var/lib/cloud/instance/scripts/part-001
# One can run this directly from this location.

echo "Running DEV startup script"

# This script will be run as root
REQUIRED_USER="root"



echo ">> Creating directory structure "
mkdir -p /app/neasaa/rajput
mkdir -p /app/neasaa/config
mkdir -p /app/neasaa/logs

mkdir -p /app/neasaa/rajput

echo ">> Creating user and group "
#To create a user named neasaa on a Linux system (like an EC2 instance), run:
groupadd app-group
useradd -m neasaa
usermod -aG app-group neasaa
groups neasaa
# Change directory owner
chown -R neasaa /app
# Set the group owner of the folder:
chgrp -R app-group /app


echo ">> Installing required s/w "

# Ensure repos are ready
until yum repolist >/dev/null 2>&1; do
    echo "Waiting for yum to be ready..."
    sleep 5
done

# To see list of installed packages:
# yum list installed

# To see all packages in yum repository:
# yum list 

# Install postgres server:
yum update -y

echo ">> Installing postgres server "
# sudo amazon-linux-extras enable postgresql14
yum install postgresql17-server postgresql17-contrib -y

echo ">> Installing java "
# Install JDK 21
yum install java-21-amazon-corretto java-21-amazon-corretto-devel -y
