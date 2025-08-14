#!/bin/bash

# -e → exit on error
# -u → treat unset variables as errors
# -o pipefail → fail if any part of a pipeline fails (not just the last command)
set -euo pipefail


# Function to log messages
log() {
    echo "[INFO] $1"
}

log "Running deployApp.sh as as user $(whoami)"

log "Unzip file /tmp/application.zip"
unzip /tmp/application.zip -d /tmp

log "Deploy libs"
sudo mv /tmp/application/app/* /app/neasaa/rajput/

log "Deploy config"
sudo mv /tmp/application/config/* /app/neasaa/config/

log "Deploy images"
sudo mv /tmp/application/images/* /app/neasaa/images/

log "Change ownership ..."
sudo chown -R app:neasaa /app

log "Script completed successfully!"