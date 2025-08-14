#!/bin/bash

# -e → exit on error
# -u → treat unset variables as errors
# -o pipefail → fail if any part of a pipeline fails (not just the last command)
set -euo pipefail

# On EC2 server check the result of this script at /var/log/cloud-init-output.log
# This file is store on EC2 at /var/lib/cloud/instance/scripts/part-001
# One can run this directly from this location.


# Function to log messages
log() {
    echo "[INFO] $1"
}


log "Running server initialization script"

log "Script is run as user $(whoami)"

# 1. Create folders
log "Creating rajpu, config, logs and images directories ..."
mkdir -p /app/neasaa/rajput
mkdir -p /app/neasaa/config
mkdir -p /app/neasaa/logs
mkdir -p /app/neasaa/images


# 2. Create group 'neasaa' if not exists
if ! getent group neasaa >/dev/null; then
    log "Creating group 'neasaa'..."
    groupadd neasaa
else
    log "Group 'neasaa' already exists."
fi

# 3. Create user 'app' if not exists
if ! id -u app >/dev/null 2>&1; then
    log "Creating user 'app'..."
    useradd -m -g neasaa app
else
    log "User 'app' already exists."
fi

# 5. Change ownership of /app recursively
log "Changing ownership of /app to app:neasaa..."
chown -R app:neasaa /app


log "Installing required s/w "

# Ensure repos are ready
until yum repolist >/dev/null 2>&1; do
    log "Waiting for yum to be ready..."
    sleep 5
done

# To see list of installed packages:
# yum list installed

# To see all packages in yum repository:
# yum list 

# Install postgres server:
yum update -y

log "Installing postgres server "
# sudo amazon-linux-extras enable postgresql14
yum install postgresql17-server postgresql17-contrib -y

log "Installing java "
yum install java-21-amazon-corretto java-21-amazon-corretto-devel -y

log "Script completed successfully!"