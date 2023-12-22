# Iagon Storage Node Service

This document provides instructions for setting up and running the Iagon storage node service in a Docker container.

## Prerequisites

Before you begin, ensure you have Docker Engine and a folder for storing Iagon data.

## Configuration

Before building and running the container, decide on the following configuration options:

- **IAGON_STORAGE_PATH**: Path inside the container where files will be stored. Default is `/mnt/iagon-storage`.
- **IAGON_STORAGE_SIZE**: The amount of storage to commit in GB. Default is `10`.
- **IAGON_SERVER_PORT**: The port for the server. Default is `1024`.
- **External Storage Path**: Path on the host machine for external storage. This will be mounted to the `IAGON_STORAGE_PATH` inside the container.

## Building and deploying the Docker Image

1. Clone the repository or download the Dockerfile and entrypoint script:

   ```bash
   git clone [repository-url]
   cd [repository-directory]
   ```

2. Build the docker image:

   ```bash
   docker build -t iagon-service .
   ```

3. Run the container using the following command, replacing /path/to/external/storage with the actual path to your designated external storage on the host system:

   ```bash
   docker run -d \
  -p 1024:1024 \
  --name iagon-provider-node \
  -v iagon-data:/root/iagon-node \
  -v /path/to/storage/folder:/mnt/iagon-storage \
  -v /path/to/host/config-backup:/backup \
  iagon-service
   ```

## Persisting Data

This container uses Docker volumes to persist data:

- Configuration Data: Stored in /root/iagon-node inside the container and persisted in a volume named iagon-data.
- Backup configuration: The configuration will additionally be copied into a local backup folder on the host from the Docker working directory.
- File Storage: The external path you provide will be mounted to /mnt/iagon-storage inside the container, persisting any data stored there.

## Updating the container

To update the service to the latest version, you'll need to rebuild the Docker image and restart the container. Here are the general steps:

1. Stop and remove the existing container:

   ```bash
   docker stop iagon-provider-node
   docker rm iagon-provider-node
   ```

2. Rebuild the image (this will fetch the latest release):

   ```bash
   docker build -t iagon-service .
   ```

3. Run the new container as described in previous steps.

## Extracting the authorization

1. View the logs for the node and read the authorization key:

   ```bash
   docker logs iagon-provider-node
   ```

2. Additionally, these logs can be used for troubleshooting issues.
