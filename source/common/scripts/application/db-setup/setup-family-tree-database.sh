#!/bin/bash

# -e → exit on error
# -u → treat unset variables as errors
# -o pipefail → fail if any part of a pipeline fails (not just the last command)
set -euo pipefail

dbSetupPath=/tmp/application/db-setup
sqlScriptFolderPath=$dbSetupPath/sql-scripts
REQUIRED_USER="postgres"

echo ">> Current user $(whoami)"
if [ "$(whoami)" != "$REQUIRED_USER" ]; then
  echo "❌ This script must be run as user '$REQUIRED_USER'."
  exit 1
fi

echo ">> Creating database users"
# Create users
psql -U postgres -d postgres -f $sqlScriptFolderPath/create-db-user.sql

echo ">> Creating family tree database"
# Create database
psql -U postgres -d postgres -f $sqlScriptFolderPath/create-db.sql

echo ">> Creating family tree schema"
# Create schema
psql -U postgres -d postgres -f $sqlScriptFolderPath/create-db-schema.sql

# Setup DB Password
psql -U postgres -f $sqlScriptFolderPath/set-db-pwd.sql

echo ">> Importing data from backup"
# Import DB Schema
psql -U postgres -d family_tree --set ON_ERROR_STOP=on --single-transaction -f $sqlScriptFolderPath/RajputChippa-20250810.sql

echo ">> Granting permission"
psql -U postgres -d family_tree --set ON_ERROR_STOP=on --single-transaction -f $sqlScriptFolderPath/grants.sql

# Exit from postgres user
echo ">> Script run successfully, exiting."
