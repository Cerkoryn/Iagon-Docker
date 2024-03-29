#!/bin/bash

# Define the configuration file or directory
CONFIG_DIR="/root/iagon-node"
IAG_CLI="/opt/Iagon/iag-cli-linux"

# Function to perform cleanup and stop the service
graceful_shutdown() {
  echo "Stopping Iagon Storage Node..."
  $IAG_CLI stop
  exit
}

# Trap TERM signal and call graceful_shutdown
trap 'graceful_shutdown' SIGTERM

if [ -d "$CONFIG_DIR" ]; then
  if [ "$(ls -A $CONFIG_DIR)" ]; then
    echo "Configuration found. Starting service..."
    $IAG_CLI start
  elif [ "$(ls -A $CONFIG_DIR)" == "" ] && [ -d "/mnt/backup/iagon-node" ] && [ "$(ls -A /mnt/backup/iagon-node)" ]; then
    echo "Configuration directory is empty. Restoring from backup..."
    cp -R /mnt/backup/iagon-node/* $CONFIG_DIR
    $IAG_CLI start
  fi
elif [ ! -d "$CONFIG_DIR" ]; then
  if [ -d "/mnt/backup/iagon-node" ] && [ "$(ls -A /mnt/backup/iagon-node)" ]; then
    echo "No configuration directory found. Creating directory and restoring from backup..."
    mkdir -p $CONFIG_DIR
    cp -R /mnt/backup/iagon-node/* $CONFIG_DIR
    $IAG_CLI start
  else
    echo "No configuration found. Please initialize the configuration manually using the following command:"
    echo "docker exec -it iagon-provider-node /bin/bash"
  fi
else
  echo "An error occurred trying to read $CONFIG_DIR."

# ***TODO: UNFORTUNATELY IT SEEMS TO GET STUCK HERE.  HOW TO FIX?***
#  echo "No configuration found. Initializing service..."
  # Command to initialize service, might need to handle input here or modify your service to accept env variables
#  $IAG_CLI start <<EOF
#$IAGON_STORAGE_PATH
#$IAGON_STORAGE_SIZE
#$IAGON_SERVER_PORT
#EOF

# Save an extra backup just in case.
#cp -R /root/iagon-node /mnt/backup/
fi

# Keep service
while true; do
    STATUS_OUTPUT=$($IAG_CLI get:status 2>&1)
    if echo "$STATUS_OUTPUT" | grep -q "Node is not running"; then
        echo "Node is not running. Attempting to restart..."
        $IAG_CLI stop
        sleep 10
        if pgrep -f "$IAG_CLI" > /dev/null; then
            echo "iag-cli-linux processes are still running. Attempting to kill..."
            pkill -f "$IAG_CLI"
        fi
        $IAG_CLI start
    fi
    sleep 60
done
