# Iagon Storage Node Service

This document provides instructions for setting up and running the Iagon storage node service in a Docker container.

### \*\*\*NOTE\*\*\*
The initial setup is not currently automated.   For the time being you will have to exec into the Docker container, finish setup manually, and then copy out your authorization key.  Additionally, it is recommended to copy out the `~/iagon-node` folder into a backup folder.  These steps are detailed below.

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

```
   git clone [repository-url]
   cd [repository-directory]
```

2. Build the docker image:

```
   docker build -t iagon-service .
```

3. Run the container using the following command, replacing /path/to/external/storage with the actual path to your designated external storage on the host system:

```
   docker run -d \
  -p 1024:1024 \
  --name iagon-provider-node \
  -v iagon-data:/root/iagon-node \
  -v /path/to/storage/folder:/mnt/iagon-storage \
  -v /path/to/host/backup:/mnt/backup \
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

```
   docker stop iagon-provider-node
   docker rm iagon-provider-node
```

2. Rebuild the image (this will fetch the latest release):

```
   docker build -t iagon-service .
```

3. Run the new container as described in previous steps.

## Extracting the authorization \*NOT CURRENTLY WORKING\*

1. View the logs for the node and read the authorization key:

```
   docker logs iagon-provider-node
```

2. Additionally, these logs can be used for troubleshooting issues.

## \*WORKAROUND\* Finishing setup manually:

1. Exec into the container using the below command: 
   
   ```
   docker exec -it iagon-provider-node /bin/bash
   ```

2. Once inside the container, from the /opt/Iagon directory run:

   ```
   ./iag-cli-linux start
   ```

3. Finish the interactive setup and copy->paste the authorization key to your host computer when finished.

4. Finally, run the following command to copy the configration out of your Docker container into a backup folder:

   ```
   cp -R /root/iagon-node /mnt/backup
   ```
   
   The configuration info will also be persisted inside the `iagon-data` Docker volume we created when running the container.  This should load automatically when you restart the container with the same command.  If not, you can copy the backup in manually.
