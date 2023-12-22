#!/bin/bash

# Define the configuration file or directory
CONFIG_DIR="/root/iagon-node"

# Check if configuration exists
if [ -d "$CONFIG_DIR" ] && [ "$(ls -A $CONFIG_DIR)" ]; then
  echo "Configuration found. Starting service..."
  # Command to start service using existing configuration
  ./iag-cli-linux start
else
  echo "No configuration found. Initializing service..."
  # Command to initialize service, might need to handle input here or modify your service to accept env variables
  # ***TODO: UNFORTUNATELY IT SEEMS TO GET STUCK HERE.  HOW TO FIX?***
  ./iag-cli-linux start <<EOF
$IAGON_STORAGE_PATH
$IAGON_STORAGE_SIZE
$IAGON_SERVER_PORT
EOF

# Save an extra backup just in case.
cp -r /root/iagon-node/* /backup/
fi

# Keep container running
tail -f /dev/null
