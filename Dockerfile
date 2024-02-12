FROM ubuntu:latest

# ************CHANGE BELOW IF NEEDED************
ENV IAGON_STORAGE_PATH=/mnt/iagon-storage
ENV IAGON_STORAGE_SIZE=1024
ENV IAGON_SERVER_PORT=1024
# ************CHANGE ABOVE IF NEEDED************

# Create a directory for Iagon
RUN mkdir -p /opt/Iagon
RUN mkdir /root/iagon-node-logs
WORKDIR /opt/Iagon

# Install wget and remove bloat
RUN apt update -y && apt install -y wget \
    && rm -rf /var/lib/apt/lists/*

# Download the latest iag-cli-linux release
RUN wget $(wget -qO- https://api.github.com/repos/Iagonorg/mainnet-node-cli/releases/latest | grep browser_download_url | grep 'iag-cli-linux' | cut -d '"' -f 4) -O iag-cli-linux

# Set permissions to execute the script
RUN chmod +rwx iag-cli-linux

# Add the entrypoint script
COPY ./entrypoint.sh /opt/Iagon/
RUN chmod +x /opt/Iagon/entrypoint.sh

# Persist configuration data
VOLUME ["/root/iagon-node"]

# Expose the necessary port
EXPOSE $IAGON_SERVER_PORT

# Run the entrypoint script.
CMD ["/opt/Iagon/entrypoint.sh"]
