#!/bin/bash
# This script starts a Docker container for the Fabric development environment,
# mapping port 8080 and mounting the Fabric configuration directory.
if [ ! -d "$HOME/.fabric-config" ]; then
  echo "ERROR: Fabric configuration directory not found at $HOME/.fabric-config"
  echo "Please create the directory and add your configuration files before running this script."
  echo "You can refer to the Fabric documentation for more details."
  echo "Exiting."
  exit 1
fi
docker run --rm -d \
  --name fabric-server \
  -p 8080:8080 \
  -v "$HOME/.fabric-config:/home/appuser/.config/fabric" \
  jimscard/fabric-yt --serve
echo "Fabric development environment is running on port 8080."
