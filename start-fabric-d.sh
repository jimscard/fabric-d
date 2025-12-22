#!/bin/bash
# This script starts a Docker container for the Fabric development environment,
# mapping port 8080 and mounting the Fabric configuration directory.
# It will run the Fabric server in detached mode with automatic restarts unless stopped.
if [[ ! -d "${HOME}/.fabric-config" ]]; then
	echo "ERROR: Fabric configuration directory not found at ${HOME}/.fabric-config"
	echo "Please create the directory and add your configuration files before running this script."
	echo "You can refer to the Fabric documentation for more details."
	echo "Exiting."
	exit 1
fi
docker run -d \
	--name fabric-server \
	--restart unless-stopped \
	-p 8080:8080 \
	-v "${HOME}/.fabric-config:/home/appuser/.config/fabric" \
	jimscard/fabric-yt:latest --serve
echo "Fabric development environment is running on port 8080."
