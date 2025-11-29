#!/bin/bash
# This script runs a Fabric command in a Docker container. It is intended for one-off use.
# It mounts the user's Fabric configuration directory into the container to preserve settings.
# Usage: ./fabric-d.sh <fabric-command> [args...]
# It uses the jimscard/fabric-yt Docker image, which adds yt-dlp to the basic fabric Docker image
# and maps port 8080 for any web services. It also uses a non-root user inside the container.
# 
# 
if [ ! -d "$HOME/.fabric-config" ]; then # Ensure the config directory exists
    mkdir -p "$HOME/.fabric-config"
    if [ $? -ne 0 ]; then
        echo "Error: Unable to create configuration directory at $HOME/.fabric-config"
        exit 1
    fi
    echo "Created configuration directory at $HOME/.fabric-config"
    echo "Please ensure your Fabric configuration files are placed in this directory."
    echo "then rerun the script with the --setup command to initialize Fabric."
    echo "You will need to set up paths in Fabric setup. The container includes yt-dlp for YouTube support."
    echo "Note that paths inside the container may differ from your host system."
    echo "For example, the home directory inside the container is /home/appuser."
    exit 0
fi
if [ $# -eq 0 ]; then
    echo "Usage: $0 <fabric-command> [args...]"
    exit 1
fi
docker run --rm -it -p 8080:8080 -v "$HOME/.fabric-config:/home/appuser/.config/fabric" jimscard/fabric-yt "$@"
# Check if the user provided a command
if [ $? -ne 0 ]; then
    echo "Error: Failed to run the Fabric command in the Docker container."
    exit 1
fi
# The command executed successfully
exit 0
