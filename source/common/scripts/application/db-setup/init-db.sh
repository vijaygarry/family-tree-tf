#!/bin/bash

# -e → exit on error
# -u → treat unset variables as errors
# -o pipefail → fail if any part of a pipeline fails (not just the last command)
set -euo pipefail


dbSetupPath=/tmp/application/db-setup
REQUIRED_USER="root"

if [ "$(whoami)" != "$REQUIRED_USER" ]; then
  echo "❌ This script must be run as user '$REQUIRED_USER'."
  exit 1
fi

# Postgres folders:
# Postgres base dir: /var/lib/pgsql/
# Postgres Data directory: /var/lib/pgsql/data
# Postgres logs directory: /var/lib/pgsql/initdb_postgresql.log


# Init db 
# When you install PostgreSQL on these systems, it does not automatically create the data directory or initial system databases. The initdb step is required to:
# Create the data directory (usually /var/lib/pgsql/data)
# Set up initial system catalogs and configuration files:
# pg_hba.conf – client authentication config
# postgresql.conf – database server settings
# Create the postgres default user and database
# Prepare the cluster for the first run
postgresql-setup initdb

# Start postgres command
systemctl start postgresql

# enable command is used to configure PostgreSQL to start automatically at boot time.
systemctl enable postgresql

# See the current status
# systemctl status postgresql

# Configure Remote Connections
# mainly copy from code just Update "#listen_addresses = 'localhost'" to  "listen_addresses = '*'"
echo "Copying file $dbSetupPath/postgresql.conf to /var/lib/pgsql/data/postgresql.conf"
cp $dbSetupPath/postgresql.conf /var/lib/pgsql/data/postgresql.conf

# Add lines to allow connections from specific IPs or all IPs (use with caution for security):
# This has updated authentication configuration.
cp $dbSetupPath/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf

# Restart:
systemctl restart postgresql